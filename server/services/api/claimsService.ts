import {
  fetchUserClaims,
  insertDiscountCode,
  setDicountCodeUsed,
} from "../../models/discountCodeModel";
import {
  fetchOfferCodeDetails,
  updateOfferTotalRedeemed,
} from "../../models/offersModel";
import { insertTransactions } from "../../models/transactionsModel";
import { subtractPointsScoreWithReturn } from "../../models/userModel";
import { IShopApiData, SHOP_PROVIDER } from "../../shared/types/integrations";
import { IClaim } from "../../shared/types/shop";
import { pool } from "../../shared/utils/db";
import { decryptShopApiParams } from "../../shared/utils/encryption";
import { insertShopDiscountCode } from "./shops";

export const issueDiscountCode = async (offerId: number, userId: string) => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const offerResult = await fetchOfferCodeDetails(offerId, client);
    if (offerResult.rows.length === 0) {
      throw new Error(`Offer with ID ${offerId} not found`);
    }

    const offerData = offerResult.rows[0];
    const amountPoints = offerData.points;
    const expirationMs = offerData.code_expiration_period;

    const apiParams: IShopApiData[] = await decryptShopApiParams([
      {
        uuid: offerData.uuid,
        api_key: offerData.api_key,
        api_url: offerData.api_url,
        shop_type: offerData.shop_type as SHOP_PROVIDER,
        consumer_key: offerData.consumer_key,
        consumer_secret: offerData.consumer_secret,
      },
    ]);

    const remainingPointsResult = await subtractPointsScoreWithReturn(
      userId,
      amountPoints,
      client
    );

    const userRemainingPoints = remainingPointsResult.rows[0]?.points;

    if (userRemainingPoints < 0) {
      await client.query("ROLLBACK");
      throw new Error("Not enough points for the transaction.");
    }
    const validUntil = new Date(Date.now() + +expirationMs);

    const response = await insertDiscountCode(
      userId,
      offerId,
      validUntil,
      client
    );

    await insertTransactions(
      [
        {
          user_id: userId,
          amount_points: amountPoints,
          offer_id: offerId.toString(),
        },
      ],
      client
    );

    await updateOfferTotalRedeemed(offerId, client);

    await insertShopDiscountCode({
      shopApiData: apiParams[0],
      codeExpirationPeriod: expirationMs,
      code: response.rows[0].code,
      apiPayloadDetails: offerResult.rows[0].api_payload,
    });

    await client.query("COMMIT");

    return response;
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error claiming discount:", err);
    throw err;
  } finally {
    client.release();
  }
};

export const claimDiscount = async (userId: string, offerId: number) => {
  const generatedCodeResponse = await issueDiscountCode(offerId, userId);
  if (!generatedCodeResponse.rowCount || generatedCodeResponse.rowCount === 0) {
    throw new Error("Failed to generate discount code");
  }

  const code = generatedCodeResponse.rows[0].code;

  return code;
};

export const getAllUserClaims = async (userId: string) => {
  const response = await fetchUserClaims(userId);
  if (!response.rowCount || response.rowCount === 0) {
    throw new Error("Failed to fetch claims");
  }

  return response.rows as IClaim[];
};

export const setClaimUsed = async (code: string) => {
  if (!code || typeof code !== "string") {
    throw new Error("Invalid code");
  }
  await setDicountCodeUsed(code);
  return true;
};
