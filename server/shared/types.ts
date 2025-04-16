import { Request } from "express";

export type IAccessToken = string;
export type IRefreshToken = string;
export type IEmailVerificationToken = string;

export interface IUser {
  uuid: string;
  email: string;
  username: string;
  password?: string;
  google_id?: string;
  created_at: string;
  steps_updated_at: string;
  points: number;
  image?: string;
  verified?: boolean;
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
  user_id: string;
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
  user_id: string;
}

export interface IDailyStepEntry {
  uuid: string;
  timestamp: string;
  total: number;
  user_id: string;
  mean: number;
}

export type IResetPasswordCode = string;

export interface IProduct {
  uuid: string;
  name: string;
  description: string;
  owner: IProductOwner;
  original_price: number;
  finpoints_price: number;
  discount: number;
  created_at: string;
  link?: string;
  image?: string;
  category: string;
  total_transactions: number;
  isAffordable?: boolean;
}

export interface IProductOwner {
  uuid: string;
  name: string;
  description: string;
  createdAt: string;
  link?: string;
  image?: string;
}

export interface ITransactionInsert {
  amount_finpoints: number;
  user_id: string;
  second_user_ids?: string[];
  product_ids?: string[];
}

export interface ITransactionEntryResponse {
  uuid: number;
  created_at: string;
  amount_finpoints?: number;
  second_user?: Partial<IUser>;
  product?: IProduct;
  user_id?: number;
}
