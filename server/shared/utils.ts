import {
  IGoogleLoginPayload,
  IGoogleSignUpPayload,
  ILoginPayload,
  ISignupPayload,
} from "../routes/auth/types";
import { IDailyStepEntry, IHourlyStepEntry } from "./types";

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
