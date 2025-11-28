import {
  IGoogleLoginPayload,
  IGoogleSignUpPayload,
  ILoginPayload,
  ISignupPayload,
} from "./types/auth";
import { IStravaActivityInfoResponse } from "./types/strava";

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

function toHex(num: number): string {
  return num.toString(16).padStart(2, "0");
}

export const generate6DigitCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

export function omitKey<T extends Record<string, any>>(
  obj: T,
  keyToRemove: string
): Omit<T, typeof keyToRemove> {
  const filteredKeys = Object.keys(obj).filter((key) => key !== keyToRemove);
  const result: Partial<T> = {};

  filteredKeys.forEach((key) => {
    result[key as keyof T] = obj[key as keyof T];
  });

  return result as Omit<T, typeof keyToRemove>;
}

export function calculatePoints(activity: IStravaActivityInfoResponse): number {
  const caloriePoints = activity.calories ?? 0;

  const timePoints = activity.moving_time / 60;

  return Math.floor(caloriePoints) + Math.floor(timePoints);
}
