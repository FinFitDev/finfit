import express, { Router, Request, Response } from "express";
import { signUpUser } from "./services/signup";
import { logInUser } from "./services/login";
import { regenerateAccessTokenFromRefreshToken } from "./services/refresh";
import { logOut } from "./services/logout";
import { ILoginPayload, ISignupPayload } from "./types";
import {
  resendEmailVerify,
  verifyAccessToken,
  verifyEmailFlow,
  verifyEmailToken,
  verifyGoogleAuth,
} from "./services/verify";
import path from "path";
import {
  resetPassword,
  resolveSendResetPasswordMail,
  verifyResetCode,
} from "./services/resetPassword";
import { RequestWithPayload } from "../../shared/types/general";

const authRouter: Router = express.Router();

authRouter.post(
  "/signup",
  async (req: RequestWithPayload<ISignupPayload>, res: Response) => {
    try {
      const user = req.body;
      const response = await signUpUser(user);

      res
        .status(201)
        .json({ message: "Sign up successful", content: response });
    } catch (error: any) {
      res.status(error.statusCode ?? 400).json({
        message: "An error occured while signing up.",
        error: error.message,
        type: error.type,
      });
    }
  }
);

authRouter.get(
  "/signup/verify",
  async (req: RequestWithPayload<undefined>, res: Response) => {
    try {
      const { token } = req.query as { token: string };
      const verification = await verifyEmailFlow(token);
      if (verification) {
        res
          .status(200)
          .sendFile(
            path.join(__dirname, "../../../views/email/success_verify.html")
          );
      }
    } catch (error) {
      res.status(500).json({
        message: "Token verification failed",
        valid_token: false,
      });
    }
  }
);

authRouter.get(
  "/signup/verify/resend",
  async (req: RequestWithPayload<undefined>, res: Response) => {
    try {
      const { user_id } = req.query as { user_id: string };
      await resendEmailVerify(user_id);

      res.status(200).json({ message: "Email resent", content: user_id });
    } catch (error: any) {
      res.status(500).json({
        message: "Failed to send verification email",
        error: error.message,
      });
    }
  }
);

authRouter.post(
  "/login",
  async (req: RequestWithPayload<ILoginPayload>, res: Response) => {
    try {
      const user = req.body;
      const { no_email } = req.query;
      const response = await logInUser(user, no_email == "true");
      res.status(200).json({ message: "Log in successful", content: response });
    } catch (error: any) {
      res.status(error.statusCode ?? 400).json({
        message: "An error occured while logging in.",
        error: error.message,
        type: error.type,
      });
    }
  }
);

authRouter.post(
  "/refresh",
  async (req: RequestWithPayload<{ refresh_token: string }>, res: Response) => {
    try {
      const refresh_token = req.body.refresh_token;
      const access_token = await regenerateAccessTokenFromRefreshToken(
        refresh_token
      );

      res.status(200).json({ access_token });
    } catch (error: any) {
      res.status(error.statusCode ?? 400).json({
        message: "An error occured while regenerating access token",
        error: error.message,
        type: error.type,
      });
    }
  }
);

authRouter.post(
  "/logout",
  async (req: RequestWithPayload<{ refresh_token: string }>, res: Response) => {
    try {
      const refresh_token = req.body.refresh_token;
      await logOut(refresh_token);

      res.status(200).json({ message: "Logout successful" });
    } catch (error: any) {
      res.status(500).json({
        message: "Could not log out",
        error: error.message,
        type: error.type,
      });
    }
  }
);

authRouter.post(
  "/verify",
  async (req: RequestWithPayload<{ access_token: string }>, res: Response) => {
    try {
      const { access_token } = req.body;
      const verification = await verifyAccessToken(access_token);
      if (verification) {
        res.status(200).json({ valid_token: true });
      }
    } catch (error) {
      res.status(500).json({
        message: "Token verification failed",
        valid_token: false,
      });
    }
  }
);

authRouter.post(
  "/googleAuth",
  async (
    req: RequestWithPayload<{ id_token: string; platform: string }>,
    res: Response
  ) => {
    try {
      const { id_token, platform } = req.body;
      const response = await verifyGoogleAuth(id_token, platform);
      res
        .status(200)
        .json({ message: "Google auth successful", content: response });
    } catch (error: any) {
      res.status(500).json({
        message: "Google auth failed",
        error: error.message,
        type: error.type,
      });
    }
  }
);

authRouter.get(
  "/signup/verify",
  async (req: RequestWithPayload<undefined>, res: Response) => {
    try {
      const { token } = req.query as { token: string };
      const verification = await verifyEmailFlow(token);
      if (verification) {
        res
          .status(200)
          .sendFile(
            path.join(__dirname, "../../../views/email/success_verify.html")
          );
      }
    } catch (error) {
      res.status(500).json({
        message: "Token verification failed",
        valid_token: false,
      });
    }
  }
);

authRouter.get(
  "/login/reset/mail",
  async (req: RequestWithPayload<undefined>, res: Response) => {
    try {
      const email = req.query.email as string;

      const user_id = await resolveSendResetPasswordMail(email);

      res
        .status(200)
        .json({ message: "Reset password email sent", content: user_id });
    } catch (error: any) {
      res.status(500).json({
        message: "Failed to send password reset email",
        error: error.message,
      });
    }
  }
);

authRouter.post(
  "/login/reset/verify",
  async (
    req: RequestWithPayload<{ code: string; user_id: string }>,
    res: Response
  ) => {
    try {
      const { code, user_id: userId } = req.body;

      const verified = await verifyResetCode(code, userId);

      if (!verified) {
        throw new Error("Reset code incorrect");
      }

      res.status(200).json({ message: "Code is correct", content: true });
    } catch (error: any) {
      res.status(500).json({
        message: "Reset code incorrect",
        error: error.message,
      });
    }
  }
);

authRouter.post(
  "/login/reset/new",
  async (
    req: RequestWithPayload<{ password: string; user_id: string }>,
    res: Response
  ) => {
    try {
      const { password, user_id: userId } = req.body;

      const updatedUserId = await resetPassword(password, userId);

      res
        .status(200)
        .json({ message: "Password was reset", content: updatedUserId });
    } catch (error: any) {
      res.status(500).json({
        message: "Password reset error",
        error: error.message,
      });
    }
  }
);

export default authRouter as Router;
