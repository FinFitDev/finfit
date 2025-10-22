import express, { Router, Request, Response } from "express";
import { setClaimUsed } from "./api/services/claimsService";

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
export default webhookRouter as Router;
