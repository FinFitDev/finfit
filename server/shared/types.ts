import { Request } from "express";

export enum ORDER_TYPE {
  ASCENDING = "ASCENDING",
  DESCENDING = "DESCENDING",
}

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

export interface IOffer {
  id: number;
  partner_id: string;
  description: string;
  points: number;
  created_at: string;
  valid_until: string;
  // category: string;
  total_redeemed: number;
  featured?: boolean;
}

export interface IPartner {
  uuid: string;
  name: string;
  description: string;
  created_at: string;
  banner_image?: string;
  link?: string;
  image?: string;
  reference_id: string;
}

export interface IDeliveryMethod {
  uuid: string;
  name: string;
  image?: string;
  description?: string;
}

export interface ITransactionEntryResponse {
  uuid: number;
  created_at: string;
  amount_finpoints?: number;
  second_users?: Partial<IUser>[];
  // products?: IProduct[];
  user_id?: number;
}

export interface IProductTransactionData {
  variant_id?: string;
  quantity: number;
  eligible?: boolean;
  id: string;
}

export interface ITransactionInsert {
  amount_finpoints: number;
  user_id: string;
  second_user_ids?: string[];
  product_data?: IProductTransactionData[];
}

export interface IFiltersQuery {
  search?: string;
  category?: string;
  min_price?: number;
  max_price?: number;
  min_finpoints?: number;
  max_finpoints?: number;
  sort_by?: string;
  order?: ORDER_TYPE;
  limit?: number;
  offset?: number;
}
