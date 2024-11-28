import bcrypt from "bcryptjs";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  fetchUserByEmail,
  fetchUserByUsername,
  insertGoogleAuthUser,
  insertUser,
} from "../../../models/userModel";
import { IGoogleSignUpPayload, ISignupPayload } from "../types";
import { isUserGoogleSignup } from "../../../shared/utils";

export const signUpUser = async (
  user: ISignupPayload | IGoogleSignUpPayload
) => {
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

  // user creates an account with google signin
  if (isUserGoogleSignup(user)) {
    return insertGoogleAuthUser(username, email, user.google_id);
  } else {
    const takenUsername = await fetchUserByUsername(username);
    if (takenUsername.rows.length > 0)
      throw new ErrorWithCode("Username is taken", 400, "username");

    const salt = await bcrypt.genSalt(10);
    const hashed_password = await bcrypt.hash(user.password, salt);

    return insertUser(username, email, hashed_password);
  }
};
