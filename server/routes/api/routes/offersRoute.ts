import { Request, Response } from "express";

import { getFeaturedOffers, getOffers } from "../services/offersService";

export const getFeaturedOffersHandler = async (req: Request, res: Response) => {
  try {
    const limit = req.query.limit;
    const offset = req.query.offset;
    const response = await getFeaturedOffers(+(limit ?? 10), +(offset ?? 0));

    res
      .status(200)
      .json({ message: "Featured offers found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching featured offers",
      error: error.message,
    });
  }
};

export const getOffersHandler = async (req: Request, res: Response) => {
  try {
    const search = req.query.search as string;
    const limit = req.query.limit;
    const offset = req.query.offset;

    const response = await getOffers(
      search ?? "",
      +(limit ?? 10),
      +(offset ?? 0)
    );

    res.status(200).json({ message: "Offers found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching offers",
      error: error.message,
    });
  }
};
