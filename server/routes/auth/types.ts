import { IAccessToken, IRefreshToken } from "../../shared/types";

export interface ILoginPayload {
  login: string;
  password: string;
}

export interface IGoogleLoginPayload {
  login: string;
  google_id: string;
}

export interface ILoginResponse {
  access_token: IAccessToken;
  refresh_token: IRefreshToken;
  user_id: string;
}

export interface ISignupPayload {
  password: string;
  email: string;
  username: string;
}

export interface IGoogleSignUpPayload {
  google_id: string;
  email: string;
  username: string;
  image?: string;
}
