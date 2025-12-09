import express, { Router, Request, Response } from "express";
import { setClaimUsed } from "../services/api/claimsService";
import { handleWebhookCodeExtraction } from "../services/api/shops/woocommerce";
import bodyParser from "body-parser";
import { verifyShopifyHmac } from "../shared/utils/integrations/shopify";
import { fetchHandler } from "../shared/utils/fetching";
import { HTTP_METHOD } from "../shared/types/general";
import {
  handleShopifyInit,
  handleShopifyWebhookCodeEvent,
} from "../services/api/shops/shopify";
import { IShopifyInitQuery } from "../shared/types/integrations/shopify";
import { RequestWithPayload } from "../shared/types";

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

webhookRouter.get(
  "/shopify/init",
  async (req: Request<any, any, any, IShopifyInitQuery>, res: Response) => {
    try {
      console.log(req.query, "HELOLO");
      const { code, shop } = req.query;
      if (!code || !shop) {
        throw new Error("Invalid query payload");
      }
      const response = await handleShopifyInit(req.query);

      if (!response) {
        throw new Error("Could not initialize shop");
      }

      res.redirect(`https://${shop}/admin/apps`);
    } catch (error: any) {
      res.status(404).json({
        message: "An error occured while resolving shopify init webhook",
        error: error.message,
        type: error.type,
      });
    }
  }
);

webhookRouter.post(
  "/shopify",
  async (
    req: RequestWithPayload<{ admin_graphql_api_id: string; title: string }>,
    res: Response
  ) => {
    try {
      console.log(req.body);
      const { admin_graphql_api_id, title } = req.body;
      const response = await handleShopifyWebhookCodeEvent(
        admin_graphql_api_id,
        title
      );

      if (!response) {
        throw new Error("Invalid response");
      }

      res.sendStatus(200);
    } catch (error: any) {
      res.status(404).json({
        message: "An error occured while resolving shopify webhook",
        error: error.message,
        type: error.type,
      });
    }
  }
);

export default webhookRouter as Router;
