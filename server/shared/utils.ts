import {
  IGoogleLoginPayload,
  IGoogleSignUpPayload,
  ILoginPayload,
  ISignupPayload,
} from "../routes/auth/types";
import { IDailyStepEntry, IHourlyStepEntry } from "./types";
import bcrypt from "bcryptjs";

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
