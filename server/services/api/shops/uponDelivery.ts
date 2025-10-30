import { access } from "fs";
import {
  fetchPartnerByPasscode,
  fetchPartnerMinimalMetadataByUuid,
} from "../../../models/partnerModel";
import { encrypt } from "../../../shared/utils/encryption";
import { generateAccessToken } from "../../../models/tokenModel";
import { getDiscountCodeForPartner } from "../../../models/discountCodeModel";

export const verifyShop = async (token: string) => {
  if (!token) {
    throw new Error("Verify token required");
  }

  const response = await fetchPartnerByPasscode(token);

  if (response.rowCount == 0 || !response.rows[0]) {
    throw new Error("Entry not found for code");
  }

  const accessToken = generateAccessToken(response.rows[0].uuid);
  return { response: response.rows[0], access_token: accessToken };
};

export const getShopMinimalMetadata = async (uuid: string) => {
  if (!uuid) {
    throw new Error("Shop UUID required");
  }

  const response = await fetchPartnerMinimalMetadataByUuid(uuid);

  if (response.rowCount == 0 || !response.rows[0]) {
    throw new Error("Entry not found for uuid");
  }

  return response.rows[0];
};

export const checkCodeValid = async (code: string, partnerId?: string) => {
  if (!code || !partnerId) {
    throw new Error("Missing credentials");
  }

  const response = await getDiscountCodeForPartner(code, partnerId);
  if (response.rowCount == 0 || !response.rows[0]) {
    throw new Error("Entry not found for uuid");
  }

  return response.rowCount! > 0;
};
