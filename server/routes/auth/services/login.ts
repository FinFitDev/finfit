import bcrypt from "bcryptjs";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import { fetchUserByUsernameOrEmail } from "../../../models/userModel";
import {
  generateAccessToken,
  generateRefreshToken,
  insertRefreshToken,
} from "../../../models/tokenModel";
import { ILoginPayload, ILoginResponse } from "../types";
import { IUser, IUserNoPassword } from "../../../shared/types";

export const logInUser = async (
  user: ILoginPayload
): Promise<ILoginResponse> => {
  if (!user) throw new ErrorWithCode("User data invalid", 400);

  const { login, password } = user;

  if (!login || !password)
    throw new ErrorWithCode("Missing user credentials", 400);

  const foundUser = await fetchUserByUsernameOrEmail(login);

  if (foundUser.rowCount === 0)
    throw new ErrorWithCode("User not found", 404, "login");

  const foundUserData: IUser = foundUser.rows[0];

  const hashed_password = foundUserData.password;

  const validPassword = await bcrypt.compare(password, hashed_password);

  if (!validPassword)
    throw new ErrorWithCode("Invalid password", 400, "password");

  const access_token = generateAccessToken(foundUserData.id);
  const refresh_token = generateRefreshToken(foundUserData.id);
  await insertRefreshToken(refresh_token, foundUserData.id);

  return { access_token, refresh_token, user_id: foundUser.rows[0].id };
};
