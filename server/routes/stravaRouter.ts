import express, { Request, Response, Router } from "express";
import {
  getStravaToken,
  handleStravaWebhookEvent,
  handleStravaWebhookVerification,
} from "../services/stravaService";
import { STRAVA_WEBHOOK_MODE } from "../shared/types/strava";

const stravaRouter: Router = express.Router();

stravaRouter.get("/auth", async (req: Request, res: Response) => {
  try {
    const code = req.query.code as string;
    const userId = req.query.user_id as string;
    const response = await getStravaToken(code, userId);

    if (!response) {
      throw new Error("Invalid response");
    }

    res.redirect("finfit://strava/auth?success=true");
  } catch (error: any) {
    console.log("Failed to auth in strava", error);
    res.redirect(`finfit://strava/auth?error=${error}`);
  }
});

stravaRouter.post("/webhook", async (req: Request, res: Response) => {
  try {
    console.log(req.body);
    const response = handleStravaWebhookEvent(req.body);
    console.log(response);

    res.status(200).json();
  } catch (error: any) {
    res.status(403);
  }
});

// verification - used only once with
// curl -X POST https://www.strava.com/api/v3/push_subscriptions \
//   -F client_id=_ \
//   -F client_secret=_ \
//   -F callback_url=_ \
//   -F verify_token=_

stravaRouter.get("/webhook", async (req: Request, res: Response) => {
  try {
    console.log(req);
    const mode = req.query["hub.mode"] as STRAVA_WEBHOOK_MODE;
    const token = req.query["hub.verify_token"] as string;
    const challenge = req.query["hub.challenge"] as string;
    const response = handleStravaWebhookVerification({
      mode,
      challenge,
      token,
    });

    if (!response) {
      throw new Error("No response");
    }

    res.status(200).json({ "hub.challenge": response });
  } catch (error: any) {
    res.sendStatus(403);
  }
});

export default stravaRouter as Router;
