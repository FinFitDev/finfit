import express, { Router, Request, Response } from "express";
import { setClaimUsed } from "../services/api/claimsService";
import { handleWebhookCodeExtraction } from "../services/api/shops/woocommerce";
import bodyParser from "body-parser";

const webhookRouter: Router = express.Router();

webhookRouter.get("/prestashop", async (req: Request, res: Response) => {
  try {
    const code = req.query.code?.toString() as string;
    const response = await setClaimUsed(code);
    res
      .status(201)
      .json({ message: "Prestashop webhook success", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 400).json({
      message: "An error occured while resolving prestashop webhook",
      error: error.message,
      type: error.type,
    });
  }
});

webhookRouter.post(
  "/woocommerce",
  bodyParser.raw({ type: "application/json", limit: "50mb" }),
  async (req: Request, res: Response) => {
    try {
      const webhookSecret = req.headers["x-wc-webhook-signature"] as string;
      const topic = req.headers["x-wc-webhook-topic"] as string;
      const rawBody = req.body as Buffer;

      const response = await handleWebhookCodeExtraction(
        webhookSecret,
        rawBody,
        topic
      );
      res
        .status(200)
        .json({ message: "Woocommerce webhook success", content: response });
    } catch (error: any) {
      // wee need to send 200 because otherwise the webhook becomes disabled
      res.status(200).json({
        message: "An error occured while resolving woocommerce webhook",
        error: error.message,
        type: error.type,
      });
    }
  }
);
export default webhookRouter as Router;
