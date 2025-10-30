import { Response } from "express";
import { RequestWithPayload } from "../../../shared/types";
import { IClaimDiscountPayload } from "../../../shared/types/offers";
import {
  claimDiscount,
  getAllUserClaims,
} from "../../../services/api/claimsService";
import { fetchUserClaims } from "../../../models/discountCodeModel";

export const claimDiscountHandler = async (
  req: RequestWithPayload<IClaimDiscountPayload, { id: number }>,
  res: Response
) => {
  try {
    const userId = req.body.user_id;
    // @ts-expect-error
    if (userId !== req.userId) {
      return res.status(401).json({
        message: "Unauthorized user",
        error: "You don't have a valid token to access this user's account",
      });
    }
    const offerId = req.params.id;
    const response = await claimDiscount(userId, offerId);

    res
      .status(200)
      .json({ message: "Discount code created", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when creating a discount code",
      error: error.message,
    });
  }
};

export const getAllClaimsHandler = async (
  req: RequestWithPayload<{ id: string }>,
  res: Response
) => {
  try {
    const userId = req.params.id;
    // @ts-expect-error
    if (userId !== req.userId) {
      return res.status(401).json({
        message: "Unauthorized user",
        error: "You don't have a valid token to access this user's account",
      });
    }
    const response = await getAllUserClaims(userId);

    res.status(200).json({ message: "User claims fetched", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching user claims",
      error: error.message,
    });
  }
};
