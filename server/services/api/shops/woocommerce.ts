import { IIssueDiscountCodeShopPayload } from "../../../shared/types/integrations/general";
import {
  formatDateForWooCommerce,
  getWooCommerceRestApi,
} from "../../../shared/utils/integrations/woocommerce";
import { setClaimUsed } from "../claimsService";
import crypto from "crypto";

export const insertWoocommerceDiscountCode = async ({
  codeExpirationPeriod,
  apiPayloadDetails,
  shopApiData,
  code,
}: IIssueDiscountCodeShopPayload) => {
  try {
    console.log(shopApiData);
    const wooCommerce = getWooCommerceRestApi(shopApiData);
    const validUntil = new Date(Date.now() + +codeExpirationPeriod);

    const response = await wooCommerce.post("coupons", {
      code: code,
      description: "API Created Discount",
      date_expires: formatDateForWooCommerce(validUntil),
      usage_limit: 1,
      usage_limit_per_user: 1,
      // details like reduction amount, type and restrictions
      ...apiPayloadDetails,
    });

    if (!response || !response.data.id) {
      throw new Error("Response failed");
    }
    console.log(response.data.id);

    return response.data;
  } catch (error) {
    console.log("error inserting woocommerce code", error);
    throw error;
  }
};

export const handleWebhookCodeExtraction = async (
  verificationCode: string,
  rawData: Buffer,
  topic: string
) => {
  if (topic != "order.updated") {
    throw new Error("Invalid event type");
  }

  const orderData = JSON.parse(rawData.toString("utf8"));

  if (orderData.status !== "completed") {
    console.log("Ignoring not completed");
    return true;
  }

  if (Object.keys(orderData).length === 1 && orderData.webhook_id) {
    console.log("Webhook test ping received");
    return true;
  }

  if (!verificationCode || !verifyWebhookSignature(rawData, verificationCode)) {
    throw new Error("Invalid event signature");
  }

  if (orderData.coupon_lines?.length && orderData.status === "completed") {
    for (const coupon of orderData.coupon_lines) {
      console.log(`Invalidating coupon: ${coupon.code}`);
      const dbResponse = await setClaimUsed(coupon.code);
      if (!dbResponse) {
        return false;
      }
    }

    return true;
  }

  return false;
};

function verifyWebhookSignature(payload: any, receivedSignature: string) {
  const VERIFY_TOKEN = process.env.WOOCOMMERCE_WEBHOOK_SECRET ?? "";

  const computedSignature = crypto
    .createHmac("SHA256", VERIFY_TOKEN)
    .update(payload)
    .digest("base64");

  return computedSignature === receivedSignature;
}
