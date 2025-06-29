import { Response } from "express";
import { RequestWithPayload } from "../../../shared/types/general";
import { ICartOrderRequestBody } from "../../../shared/types/orders";
import { handleCreateCartOrders } from "../services/orders";

export const createCartOrder = async (
  req: RequestWithPayload<ICartOrderRequestBody[]>,
  res: Response
) => {
  try {
    const orderData = req.body;

    const response = await handleCreateCartOrders(orderData);

    res.status(200).json({ message: "Cart orders created", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when creating cart orders",
      error: error.message,
    });
  }
};
