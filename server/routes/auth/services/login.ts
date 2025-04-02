import bcrypt from "bcryptjs";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import { fetchUserByUsernameOrEmail } from "../../../models/userModel";
import {
  generateAccessToken,
  generateEmailVerificationToken,
  generateRefreshToken,
  insertRefreshToken,
} from "../../../models/tokenModel";
import { IGoogleLoginPayload, ILoginPayload, ILoginResponse } from "../types";
import { IUser } from "../../../shared/types";
import { isUserGoogleLogin } from "../../../shared/utils";
import { sendVerificationEmail } from "../../../shared/utils/email";

export const logInUser = async (
  user: ILoginPayload | IGoogleLoginPayload,
  noEmail = false
): Promise<ILoginResponse> => {
  if (!user) throw new ErrorWithCode("User data invalid", 400);

  const { login } = user;

  if (!login || (isUserGoogleLogin(user) ? !user.google_id : !user.password))
    throw new ErrorWithCode("Missing user credentials", 400);

  const foundUser = await fetchUserByUsernameOrEmail(login);

  if (foundUser.rowCount === 0)
    throw new ErrorWithCode("User not found", 404, "login");

  const foundUserData: IUser = foundUser.rows[0];

  if (isUserGoogleLogin(user)) {
    const googleId = foundUserData.google_id;
    const validGoogleId = googleId === user.google_id;

    if (!validGoogleId) throw new ErrorWithCode("Invalid google id", 400);
  } else {
    const hashedPassword = foundUserData.password;

    const validPassword = await bcrypt.compare(user.password, hashedPassword!);

    if (!validPassword)
      throw new ErrorWithCode("Invalid password", 400, "password");
  }

  // we will request email verification first
  if (!foundUserData.verified) {
    if (!noEmail) {
      const emailVerificationToken = generateEmailVerificationToken(
        foundUserData.uuid
      );
      await sendVerificationEmail(
        foundUserData.email,
        emailVerificationToken,
        foundUserData.username
      );
    }
    return { user_id: foundUserData.uuid };
  }

  const access_token = generateAccessToken(foundUserData.uuid);
  const refresh_token = generateRefreshToken(foundUserData.uuid);
  await insertRefreshToken(refresh_token, foundUserData.uuid);

  return { access_token, refresh_token, user_id: foundUserData.uuid };
};
