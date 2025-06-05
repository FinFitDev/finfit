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

export interface IProductVariant {
  id: string;
  discount: number;
  price: number;
  in_stock: number;
  images?: string[];
  attributes: Record<string, string>;
}

export interface IProduct {
  uuid: string;
  name: string;
  description: string;
  product_owner: IProductOwner;
  original_price: number;
  finpoints_price: number;
  discount: number;
  created_at: string;
  link?: string;
  images: string[];
  category: string;
  total_transactions: number;
  isAffordable?: boolean;
  variants: IProductVariant[];
}

export interface IProductOwner {
  uuid: string;
  name: string;
  description: string;
  createdAt: string;
  total_transactions: number;
  total_products: number;
  banner_image?: string;
  link?: string;
  image?: string;
  reference_id: string;
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
