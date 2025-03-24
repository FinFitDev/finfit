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

export function generateSeed(): string {
  const random = Math.random;
  const backgroundColor = `FF${randomLightColor()}`;
  const shapeParts: string[] = [];

  // Generate a random type between 0 and 2
  const type = Math.floor(random() * 3);

  // Generate 5 shape parts
  for (let i = 0; i < 5; i++) {
    const color = `FF${randomColor()}`; // Random color for shape
    const x = Math.floor(random() * 50); // Random x coordinate between 0 and 50
    const y = Math.floor(random() * 50); // Random y coordinate between 0 and 50
    const width = Math.floor(random() * 21) + (60 - i * 10); // Random width between 20 and 100
    const height = Math.floor(random() * 21) + (60 - i * 10); // Random height between 20 and 100
    const angle = Math.floor(random() * 361); // Random angle between 0 and 360

    // Construct the shape part
    const shapePart = `${color}_${x}_${y}_${width}_${height}_${angle}`;

    shapeParts.push(shapePart);
  }

  return `${type}|${backgroundColor}|${shapeParts.join("|")}`;
}

function randomColor(): string {
  const r = Math.floor(Math.random() * 150);
  const g = Math.floor(Math.random() * 150);
  const b = Math.floor(Math.random() * 150);
  return toHex(r) + toHex(g) + toHex(b);
}

function randomLightColor(): string {
  const r = Math.floor(Math.random() * 50) + 200;
  const g = Math.floor(Math.random() * 50) + 200;
  const b = Math.floor(Math.random() * 50) + 200;
  return toHex(r) + toHex(g) + toHex(b);
}

function toHex(num: number): string {
  return num.toString(16).padStart(2, "0");
}

export const generate6DigitCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

// export function convertObjectToDBTuple<T extends Record<string, any>>(data:T[]){
//   return data.reduce((acc, obj) => {
//     const sortedObj = Object.keys(obj)
//     .sort()
//     .reduce((result: Record<string, any>, key) => {
//       result[key] = obj[key];
//       return result;
//     }, {});

//     acc += `(${Object.values(sortedObj).join(', ')}),`
//     return acc
//   },'')

// }
