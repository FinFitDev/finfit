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

export type IResetPasswordCode = string;
