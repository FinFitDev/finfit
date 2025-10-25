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
  points: number;
  image?: string;
  verified?: boolean;
  total_points_earned: number;
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
  created_at?: string;
  strava_id?: number;
  polyline?: string;
  elevation_change?: number;
  average_speed?: number;
}

export interface ITrainingEntryResponse {
  id: number;
  created_at: string;
  points: number;
  duration: number;
  calories?: number;
  distance?: number;
  type: string;
  strava_id?: number;
  polyline?: string;
  elevation_change?: number;
  average_speed?: number;
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
  catch: string;
  details: string;
  // category: string;
  total_redeemed: number;
  featured?: boolean;
  api_payload?: string;
  code_expiration_period: number;
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

export interface IOfferWithPartner extends IOffer {
  partner: IPartner;
}

export interface ITransactionEntryResponse {
  uuid: number;
  created_at: string;
  amount_finpoints?: number;
  second_users?: Partial<IUser>[];
  offer?: IOfferWithPartner;
  user_id?: number;
}

export interface ITransactionInsert {
  amount_points: number;
  user_id: string;
  second_user_ids?: string[];
  offer_id?: string;
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
