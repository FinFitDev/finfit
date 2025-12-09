import {
  fetchProductOwnerAPIByAPIURL,
  insertIntoPartners,
} from "../../../models/partnerModel";
import { HTTP_METHOD } from "../../../shared/types/general";
import { SHOP_PROVIDER } from "../../../shared/types/integrations";
import { IIssueDiscountCodeShopPayload } from "../../../shared/types/integrations/general";
import { IShopifyInitQuery } from "../../../shared/types/integrations/shopify";
import { decrypt, encrypt } from "../../../shared/utils/encryption";
import { fetchHandler } from "../../../shared/utils/fetching";
import {
  createShopifyDiscountCodeForPriceRule,
  createShopifyPriceRule,
  createShopifyWebhook,
  getShopifyAccessToken,
  getShopifyDiscountDetails,
  verifyShopifyHmac,
} from "../../../shared/utils/integrations/shopify";
import { setClaimUsed } from "../claimsService";

export const handleShopifyInit = async (query: IShopifyInitQuery) => {
  const { shop, code } = query;
  const clientSecret = process.env.SHOPIFY_API_SECRET;
  const clientId = process.env.SHOPIFY_API_KEY;
  if (!clientSecret || !clientId) {
    throw new Error("Shopify Client credentials not complete");
  }

  const isValid = verifyShopifyHmac(query, clientSecret);
  console.log(isValid);
  if (!isValid) {
    throw new Error("HMAC verification failed");
  }

  const accessToken = await getShopifyAccessToken({
    code,
    shop,
  });

  console.log(accessToken);

  await insertIntoPartners({
    name: shop,
    description: "",
    apiKey: encrypt(code),
    apiUrl: shop,
    shopType: SHOP_PROVIDER.SHOPIFY,
  });

  const responseWebhookCreate = await createShopifyWebhook({
    shop,
    apiKey: accessToken,
  });

  console.log(responseWebhookCreate);

  return true;
};

export const insertShopifyDiscountCode = async ({
  codeExpirationPeriod,
  apiPayloadDetails,
  shopApiData,
  code,
}: IIssueDiscountCodeShopPayload) => {
  const responsePriceRule = await createShopifyPriceRule({
    codeExpirationPeriod,
    apiPayloadDetails,
    shopApiData,
  });

  if (!responsePriceRule.price_rule.id) {
    throw new Error("Invalid price rule");
  }

  const discountCodeResponse = await createShopifyDiscountCodeForPriceRule({
    priceRuleId: responsePriceRule.price_rule.id,
    code,
    shopApiData,
  });

  console.log(discountCodeResponse);

  return !!discountCodeResponse.id;
};

export const handleShopifyWebhookCodeEvent = async (
  id: string,
  title: string
) => {
  if (!id) {
    throw new Error("Invalid admin id");
  }

  if (!title || !title.startsWith("FINFIT_PARTNER_DISCOUNT")) {
    throw new Error("Invalid discount title");
  }

  const shopUrl = title.substring(24);

  if (!shopUrl) {
    throw new Error("Invalid shop url");
  }

  const response = await fetchProductOwnerAPIByAPIURL(shopUrl);

  const apiKey = decrypt(response[0].api_key);
  const responseCode = await getShopifyDiscountDetails(id, apiKey, shopUrl);

  const dbResponse = await setClaimUsed(responseCode);
  if (!dbResponse) {
    return false;
  }

  return true;
};
