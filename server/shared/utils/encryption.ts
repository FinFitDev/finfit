import crypto, { BinaryLike, CipherKey } from "crypto";
import { IShopApiData } from "../types/integrations";

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

export function decryptShopApiParams(shopApiParams: IShopApiData[]) {
  return shopApiParams.map((param) => ({
    ...param,
    api_key: param.api_key ? decrypt(param.api_key) : undefined,
    consumer_secret: param.consumer_secret
      ? decrypt(param.consumer_secret)
      : undefined,
  }));
}
