import {
  IGoogleLoginPayload,
  IGoogleSignUpPayload,
  ILoginPayload,
  ISignupPayload,
} from "../routes/auth/types";

import crypto from "crypto";
import { IDailyStepEntry, IHourlyStepEntry } from "./types/activity";
import {
  IProductQuantitiesData,
  IShopApiData,
  StockItem,
} from "./types/synchronization";

export const isUserGoogleLogin = (
  user: ILoginPayload | IGoogleLoginPayload
): user is IGoogleLoginPayload => {
  if ("google_id" in user) {
    return true;
  }
  return false;
};

export const isUserGoogleSignup = (
  user: ISignupPayload | IGoogleSignUpPayload
): user is IGoogleSignUpPayload => {
  if ("google_id" in user) {
    return true;
  }
  return false;
};

export const getUtcMidnightDate = (date: Date) => {
  return new Date(
    Date.UTC(
      date.getUTCFullYear(),
      date.getUTCMonth(),
      date.getUTCDate(),
      0,
      0,
      0,
      0
    )
  );
};

export const aggregateDailyDataObject = (data: IHourlyStepEntry[]) => {
  return data.reduce((acc: Record<string, IDailyStepEntry>, item) => {
    const date = new Date(item.timestamp);
    const utcMidnightDate = getUtcMidnightDate(date);
    const uuid = `${utcMidnightDate.toISOString()}_${item.user_id}`;
    if (Object.keys(acc).includes(uuid)) {
      acc[uuid].total += item.total;
      acc[uuid].mean += item.total / 24;
    } else {
      acc[uuid] = {
        timestamp: `${utcMidnightDate.toISOString()}`,
        uuid,
        total: item.total,
        mean: item.total / 24,
        user_id: item.user_id,
      };
    }
    return acc;
  }, {});
};

function toHex(num: number): string {
  return num.toString(16).padStart(2, "0");
}

export const generate6DigitCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

export function encrypt(text: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(
    "aes-256-gcm",
    Buffer.from(process.env.SHOP_API_ENCRYPTION_KEY!),
    iv
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
    Buffer.from(process.env.SHOP_API_ENCRYPTION_KEY!),
    iv
  );
  decipher.setAuthTag(authTag);

  let decrypted = decipher.update(data, "hex", "utf8");
  decrypted += decipher.final("utf8");

  return decrypted;
}

export function decryptShopApiParams(shopApiParams: IShopApiData[]) {
  return shopApiParams.map((param) => ({
    ...param,
    api_key: decrypt(param.api_key!),
  }));
}

export const convertStockListToProducts = (
  stockItems: StockItem[]
): IProductQuantitiesData[] => {
  const productMap = new Map<number, IProductQuantitiesData>();

  stockItems.forEach(({ productId, idProductAttribute, quantity, id }) => {
    if (!productMap.has(productId)) {
      productMap.set(productId, {
        productId: productId.toString(),
        quantity: 0,
        variants: [],
      });
    }

    const product = productMap.get(productId)!;

    if (idProductAttribute === 0) {
      product.quantity = quantity;
    } else {
      product.variants.push({
        variantId: idProductAttribute.toString(),
        quantity,
      });
    }
  });

  return Array.from(productMap.values());
};
