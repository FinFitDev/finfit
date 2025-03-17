import { getCodeByCodeFromDb } from "../../../models/codeModel";
import { generateEmailVerificationToken } from "../../../models/tokenModel";
import { fetchUserByEmail } from "../../../models/userModel";
import { generate6digitCode } from "../../../shared/utils";
import {
  sendPasswordResetEmail,
  sendVerificationEmail,
} from "../../../shared/utils/email";

export const resolveSendResetPasswordMail = async (email: string) => {
  if (!email) {
    throw new Error("No email provided");
  }

  const foundUser = await fetchUserByEmail(email);
  if (foundUser.rowCount === 0) {
    throw new Error("User not found");
  }

  await generatePasswordResetEmail(email, foundUser.rows[0].username);

  return foundUser.rows[0].id;
};

export const generatePasswordResetEmail = async (
  email: string,
  username: string
): Promise<void> => {
  if (!username || !email) {
    throw new Error("Invalid user data");
  }

  let tries = 0;
  let code;
  let foundCode;

  while (tries < 5 && foundCode) {
    code = generate6digitCode();
    foundCode = await getCodeByCodeFromDb(code);
    tries++;
  }

  if (!code) {
    throw new Error("Failed to generate code");
  }

  await sendPasswordResetEmail(email, code, username);
};
