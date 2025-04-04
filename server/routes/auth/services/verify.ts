import jwt from "jsonwebtoken";
import { getDataFromIdToken } from "../../../shared/utils/google";
import {
  fetchUserByEmail,
  fetchUserById,
  updateVerifyUser,
} from "../../../models/userModel";
import { logInUser } from "./login";
import { signUpUser } from "./signup";
import { generateEmailVerificationToken } from "../../../models/tokenModel";
import { sendVerificationEmail } from "../../../shared/utils/email";

export const verifyAccessToken = (access_token: string) => {
  return new Promise((resolve, reject) => {
    jwt.verify(access_token, process.env.JWT_SECRET as string, (err, data) => {
      if (err) {
        reject("Token invalid or expired");
      } else if (data) resolve(data);
    });
  });
};

export const resendEmailVerify = async (user_id: string) => {
  if (!user_id) {
    throw new Error("Invalid user_id");
  }
  const response = await fetchUserById(user_id);
  if (response.rowCount === 0) {
    throw new Error(`No user found with id ${user_id}`);
  }

  const user = response.rows[0];

  const emailVerificationToken = generateEmailVerificationToken(user_id);
  await sendVerificationEmail(
    user.email,
    emailVerificationToken,
    user.username
  );
};

export const verifyEmailToken = (email_token: string) => {
  return new Promise((resolve, reject) => {
    jwt.verify(email_token, process.env.EMAIL_SECRET as string, (err, data) => {
      if (err) {
        reject("Token invalid or expired");
      } else if (data) resolve(data);
    });
  });
};

export const verifyEmailFlow = async (email_token: string) => {
  if (!email_token) {
    throw new Error("Invalid verification token");
  }

  const verifyToken = await verifyEmailToken(email_token);

  if (!(verifyToken as any).user_id) {
    throw new Error("Invalid verification");
  }

  const updateUserVerified = await updateVerifyUser(
    (verifyToken as any).user_id as string
  );

  return updateUserVerified.command === "UPDATE";
};

export const verifyGoogleAuth = async (id_token: string, platform: string) => {
  const payload = await getDataFromIdToken(id_token, platform);

  if (!payload?.email) throw new Error("Error veryfing user data");

  const takenEmail = await fetchUserByEmail(payload.email);
  if (takenEmail.rows.length > 0) {
    // the email address has already been used in a traditional account creation (username, email, password)*
    if (takenEmail.rows[0].google_id === "NULL") {
      throw new Error("Email already in use.");
    }

    const response = await logInUser({
      login: payload.email,
      google_id: payload.sub,
    });
    return response;
  } else {
    const signUpResponse = await signUpUser({
      username: payload.name ?? payload.sub.slice(10),
      email: payload.email,
      google_id: payload.sub,
      image: payload.picture,
    });

    if (signUpResponse) {
      const logInResponse = await logInUser({
        login: payload.email,
        google_id: payload.sub,
      });

      return logInResponse;
    }

    return signUpResponse;
  }
};
