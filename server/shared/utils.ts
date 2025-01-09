import {
  IGoogleLoginPayload,
  IGoogleSignUpPayload,
  ILoginPayload,
  ISignupPayload,
} from "../routes/auth/types";

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