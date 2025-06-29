import {
  IAccessToken,
  IEmailVerificationToken,
  IRefreshToken,
} from "../shared/types/auth";
import { pool } from "../shared/utils/db";
import jwt from "jsonwebtoken";

export interface ITokenData {
  user_id: string;
}

export const generateEmailVerificationToken = (
  user_id: string
): IEmailVerificationToken => {
  const token_data: ITokenData = {
    user_id,
  };
  return jwt.sign(token_data, process.env.EMAIL_SECRET as string, {
    expiresIn: "10m",
  });
};

export const generateAccessToken = (user_id: string): IAccessToken => {
  const token_data: ITokenData = {
    user_id,
  };
  return jwt.sign(token_data, process.env.JWT_SECRET as string, {
    expiresIn: "10m",
  });
};

export const generateRefreshToken = (user_id: string): IRefreshToken => {
  const token_data: ITokenData = {
    user_id,
  };
  return jwt.sign(token_data, process.env.REFRESH_SECRET as string);
};

export const insertRefreshToken = async (
  refresh_token: IRefreshToken,
  user_id: string
) => {
  try {
    await deleteExistingRefreshToken(user_id);

    const response = await pool.query(
      "INSERT INTO refresh_tokens (token,user_id) VALUES ($1,$2)",
      [refresh_token, user_id]
    );

    return response;
  } catch (error: any) {
    return error;
  }
};

export const deleteExistingRefreshToken = async (user_id: string) => {
  const response = await pool.query(
    "DELETE FROM refresh_tokens rt WHERE rt.user_id = $1",
    [user_id]
  );

  return response;
};

export const fetchTokenFromDb = async (refresh_token: IRefreshToken) => {
  const response = await pool.query(
    "SELECT * FROM refresh_tokens rt WHERE rt.token = $1",
    [refresh_token]
  );

  return response;
};

export const deleteTokenFromDb = async (refresh_token: IRefreshToken) => {
  const response = await pool.query(
    "DELETE FROM refresh_tokens rt WHERE rt.token = $1",
    [refresh_token]
  );

  return response;
};
