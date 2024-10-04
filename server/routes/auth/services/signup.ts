import bcrypt from "bcryptjs";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  fetchUserByEmail,
  fetchUserByUsername,
  insertUser,
} from "../../../models/userModel";
import { ISignupPayload } from "../types";

export const signUpUser = async (user: ISignupPayload) => {
  if (!user) throw new ErrorWithCode("User data invalid", 400);
  const { username, email, password } = user;

  if (!username || !email || !password)
    throw new ErrorWithCode("Missing user credentials", 400);

  if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email))
    throw new ErrorWithCode("Invalid email", 400, "email");

  const takenUsername = await fetchUserByUsername(username);
  if (takenUsername.rows.length > 0)
    throw new ErrorWithCode("Username is taken", 400, "username");

  const takenEmail = await fetchUserByEmail(email);
  if (takenEmail.rows.length > 0)
    throw new ErrorWithCode("Email is taken", 400, "email");

  const salt = await bcrypt.genSalt(10);
  const hashed_password = await bcrypt.hash(password, salt);

  return insertUser(username, email, hashed_password);
};
