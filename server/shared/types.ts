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
  steps_updated_at: string;
  points: number;
  image?: string;
}

export type IUserNoPassword = Omit<IUser, "password">;

export interface RequestWithPayload<T, S = any> extends Request<S> {
  body: T;
}

export interface ITrainingEntry {
  points: number;
  duration: number;
  calories?: number;
  distance?: number;
  type: string;
  user_id: number;
  uuid: number;
  created_at?: string;
}

export interface ITrainingEntryResponse {
  id: number;
  created_at: string;
  points: number;
  duration: number;
  calories?: number;
  distance?: number;
  type: string;
}

export interface IHourlyStepEntry {
  uuid: string;
  timestamp: string;
  total: number;
  user_id: number;
}

export interface IDailyStepEntry {
  uuid: string;
  timestamp: string;
  total: number;
  user_id: number;
  mean: number;
}
