import crypto, { BinaryLike, CipherKey } from "crypto";
import { IShopApiData, SHOP_PROVIDER } from "../types/integrations";
import { getShopifyAccessToken } from "./integrations/shopify";

export function encrypt(text: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    "aes-256-gcm",
    Buffer.from(process.env.SHOP_API_ENCRYPTION_KEY!) as CipherKey,
    iv as BinaryLike
  );

  let encrypted = cipher.update(text, "utf8", "hex");
  encrypted += cipher.final("hex");
  const authTag = cipher.getAuthTag().toString("hex");

  return `${iv.toString("hex")}:${authTag}:${encrypted}`;
}

export function decrypt(encrypted: string): string {
  const [ivHex, authTagHex, data] = encrypted.split(":");
  const iv = Buffer.from(ivHex, "hex");
  const authTag = Buffer.from(authTagHex, "hex");

  const decipher = crypto.createDecipheriv(
    "aes-256-gcm",
    Buffer.from(process.env.SHOP_API_ENCRYPTION_KEY!) as CipherKey,
    iv as BinaryLike
  );
  decipher.setAuthTag(authTag as NodeJS.ArrayBufferView);

  let decrypted = decipher.update(data, "hex", "utf8");
  decrypted += decipher.final("utf8");

  return decrypted;
}

export async function decryptShopApiParams(
  shopApiParams: IShopApiData[]
): Promise<IShopApiData[]> {
  return await Promise.all(
    shopApiParams.map(async (param) => {
      const isUponDelivery = param.shop_type === SHOP_PROVIDER.UPON_DELIVERY;

      let decryptedApiKey: string | undefined;

      if (param.api_key && !isUponDelivery) {
        decryptedApiKey = decrypt(param.api_key);

        // if (param.shop_type === SHOP_PROVIDER.SHOPIFY) {
        //   decryptedApiKey = await getShopifyAccessToken({
        //     code: decryptedKey,
        //     shop: param.api_url,
        //   });
        // } else {
        //   decryptedApiKey = decryptedKey;
        // }
      } else {
        decryptedApiKey = undefined;
      }

      const decryptedConsumerSecret = param.consumer_secret
        ? decrypt(param.consumer_secret)
        : undefined;

      return {
        ...param,
        api_key: decryptedApiKey,
        consumer_secret: decryptedConsumerSecret,
      };
    })
  );
}
