import { deleteTokenFromDb } from "../../../models/tokenModel";
import { IRefreshToken } from "../../../shared/types";

export const logOut = async (refresh_token: IRefreshToken) => {
  await deleteTokenFromDb(refresh_token);
};
