import { deleteTokenFromDb } from "../../../models/tokenModel";
import { IRefreshToken } from "../../../shared/types/auth";

export const logOut = async (refresh_token: IRefreshToken) => {
  await deleteTokenFromDb(refresh_token);
};
