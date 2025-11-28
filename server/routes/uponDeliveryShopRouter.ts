import express, { Request, Response, Router } from "express";
import {
  checkCodeValid,
  getShopMinimalMetadata,
} from "../services/api/shops/uponDelivery";
import { setClaimUsed } from "../services/api/claimsService";
import { RequestWithPayload } from "../shared/types";

const uponDeliveryRouter: Router = express.Router();

uponDeliveryRouter.get(
  "/metadata/:id",
  async (req: Request<{ id: string }>, res: Response) => {
    try {
      const uuid = req.params.id;
      const response = await getShopMinimalMetadata(uuid);
      res
        .status(200)
        .json({ message: "Shop metadata found", content: response });
    } catch (error: any) {
      res.status(500).json({
        message: "Shop metadata not found",
        error: error.message,
      });
    }
  }
);

uponDeliveryRouter.post(
  "/code/check/:code",
  async (
    req: RequestWithPayload<{ partner_id: string }, { code: string }>,
    res: Response
  ) => {
    try {
      const code = req.params.code;
      const partnerId = req.body.partner_id;
      const response = await checkCodeValid(code, partnerId);
      res.status(200).json({ message: "Code valid", content: response });
    } catch (error: any) {
      res.status(500).json({
        message: "Code invalid",
        error: error.message,
      });
    }
  }
);

uponDeliveryRouter.post(
  "/code/mark/:code",
  async (req: Request<{ code: string }>, res: Response) => {
    try {
      const code = req.params.code;

      const response = await setClaimUsed(code);
      res.status(200).json({ message: "Code claimed", content: response });
    } catch (error: any) {
      res.status(500).json({
        message: "Error claiming code",
        error: error.message,
      });
    }
  }
);

export default uponDeliveryRouter as Router;
