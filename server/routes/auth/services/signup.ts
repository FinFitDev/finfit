import bcrypt from "bcryptjs";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  fetchUserByEmail,
  fetchUserById,
  fetchUserByUsername,
  insertGoogleAuthUser,
  insertUser,
} from "../../../models/userModel";
import { IGoogleSignUpPayload, ISignupPayload } from "../types";
import { generateSeed, isUserGoogleSignup } from "../../../shared/utils";
import { v4 as uuidv4 } from "uuid";
import { sendVerificationEmail } from "../../../shared/utils/email";
import { generateEmailVerificationToken } from "../../../models/tokenModel";

export const signUpUser = async (
  user: ISignupPayload | IGoogleSignUpPayload
): Promise<{ user_id: string }> => {
  if (!user) throw new ErrorWithCode("User data invalid", 400);

  const { username, email } = user;

  if (
    !username ||
    !email ||
    (isUserGoogleSignup(user) ? !user.google_id : !user.password)
  )
    throw new ErrorWithCode("Missing user credentials", 400);

  if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email))
    throw new ErrorWithCode("Invalid email", 400, "email");

  const takenEmail = await fetchUserByEmail(email);
  if (takenEmail.rows.length > 0)
    throw new ErrorWithCode("Email is taken", 400, "email");

  let uuid;
  // user creates an account with google signin
  if (isUserGoogleSignup(user)) {
    const goolgeResponse = await insertGoogleAuthUser(
      username,
      email,
      user.google_id,
      generateSeed()
    );
    uuid = goolgeResponse.rows[0].uuid;
  } else {
    const takenUsername = await fetchUserByUsername(username);
    if (takenUsername.rows.length > 0)
      throw new ErrorWithCode("Username is taken", 400, "username");

    const salt = await bcrypt.genSalt(10);
    const hashed_password = await bcrypt.hash(user.password, salt);

    const response = await insertUser(
      username,
      email,
      hashed_password,
      generateSeed()
    );
    uuid = response.rows[0].uuid;

    const emailVerificationToken = generateEmailVerificationToken(uuid);
    await sendVerificationEmail(email, emailVerificationToken, username);
  }

  return { user_id: uuid };
};
