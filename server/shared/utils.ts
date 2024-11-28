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
