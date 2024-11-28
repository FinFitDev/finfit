import express, { Router, Request, Response } from "express";
import { signUpUser } from "./services/signup";
import { logInUser } from "./services/login";
import { regenerateAccessTokenFromRefreshToken } from "./services/refresh";
import { logOut } from "./services/logout";
import { RequestWithPayload } from "../../shared/types";
import { ILoginPayload, ISignupPayload } from "./types";
import { verifyAccessToken, verifyGoogleAuth } from "./services/verify";

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

authRouter.post(
  "/login",
  async (req: RequestWithPayload<ILoginPayload>, res: Response) => {
    try {
      const user = req.body;
      const response = await logInUser(user);
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
  async (req: RequestWithPayload<{ id_token: string }>, res: Response) => {
    try {
      const { id_token } = req.body;
      const response = await verifyGoogleAuth(id_token);
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

export default authRouter as Router;
