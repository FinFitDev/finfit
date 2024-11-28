import { Request } from "express";

export type IAccessToken = string;
export type IRefreshToken = string;

export interface IUser {
  id: number;
  email: string;
  username: string;
  password?: string;
  google_id?: string;
  created_at: string;
  updated_at: string;
  points: number;
  image?: string;
}

export type IUserNoPassword = Omit<IUser, "password">;

export interface RequestWithPayload<T, S = any> extends Request<S> {
  body: T;
}
