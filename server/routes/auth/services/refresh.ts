import "dotenv/config";
import jwt from "jsonwebtoken";

import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  generateAccessToken,
  fetchTokenFromDb,
  ITokenData,
} from "../../../models/tokenModel";
import { IAccessToken, IRefreshToken } from "../../../shared/types";

export const regenerateAccessTokenFromRefreshToken = async (
  refresh_token: IRefreshToken
) => {
  if (!refresh_token) throw new ErrorWithCode("You are not authorized", 401);
  const found_token = await fetchTokenFromDb(refresh_token);

  if (found_token.rowCount == 0)
    throw new ErrorWithCode("Invalid refresh token", 403);

  let access_token: IAccessToken = "";

  jwt.verify(
    refresh_token,
    process.env.REFRESH_SECRET as string,
    (err, data) => {
      if (err || !data) throw new ErrorWithCode("Invalid refresh token", 403);

      access_token = generateAccessToken((data as ITokenData).user_id);
    }
  );

  return access_token;
};
