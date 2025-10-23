import bcrypt from "bcryptjs";
import { fetchUserByEmail, updateUserPassword } from "../../models/userModel";
import {
  getCodeByCodeFromDb,
  getCodeByUserIdFromDb,
  insertCodeToDb,
} from "../../models/codeModel";
import { generate6DigitCode } from "../../shared/utils";
import { sendPasswordResetEmail } from "../../shared/utils/email";

export const resolveSendResetPasswordMail = async (email: string) => {
  if (!email) {
    throw new Error("No email provided");
  }

  const foundUser = await fetchUserByEmail(email);
  // Cannot reset password for google auth user
  if (foundUser.rowCount === 0 || foundUser.rows[0].google_id !== "NULL") {
    throw new Error("User not found");
  }

  const code = await generatePasswordResetEmail(
    email,
    foundUser.rows[0].username
  );

  const salt = await bcrypt.genSalt(10);
  const hashed_code = await bcrypt.hash(code, salt);

  await insertCodeToDb(hashed_code, foundUser.rows[0].uuid);

  return foundUser.rows[0].uuid;
};

export const generatePasswordResetEmail = async (
  email: string,
  username: string
): Promise<string> => {
  if (!username || !email) {
    throw new Error("Invalid user data");
  }

  let tries = 0;
  let code = generate6DigitCode();
  let foundCode = await getCodeByCodeFromDb(code);

  while (tries < 5 && foundCode) {
    code = generate6DigitCode();
    foundCode = await getCodeByCodeFromDb(code);
    tries++;
  }

  if (!code) {
    throw new Error("Failed to generate code");
  }

  await sendPasswordResetEmail(email, code, username);
  return code;
};

export const verifyResetCode = async (code: string, userId: string) => {
  if (!code) {
    throw new Error("No code provided");
  }
  if (!userId) {
    throw new Error("No userId provided");
  }

  const foundCodeEntry = await getCodeByUserIdFromDb(userId);

  if (foundCodeEntry.rowCount === 0) {
    throw new Error("No code found for user");
  }

  return await bcrypt.compare(code, foundCodeEntry.rows[0].code);
};

export const resetPassword = async (password: string, userId: string) => {
  if (!password) {
    throw new Error("No new password provided");
  }
  if (!userId) {
    throw new Error("No userId provided");
  }

  const salt = await bcrypt.genSalt(10);
  const hashed_password = await bcrypt.hash(password, salt);

  const response = await updateUserPassword(userId, hashed_password);
  if (response.rowCount === 0) {
    throw new Error("Password not updated");
  }

  return userId;
};
