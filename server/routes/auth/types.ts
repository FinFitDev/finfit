import { IAccessToken, IRefreshToken } from "../../shared/types";

export interface ILoginPayload {
  login: string;
  password: string;
}

export interface ILoginResponse {
  access_token: IAccessToken;
  refresh_token: IRefreshToken;
  user_id: number;
}

export interface ISignupPayload {
  login: string;
  password: string;
  email: string;
  username: string;
}
