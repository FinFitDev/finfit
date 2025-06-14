import { Request, Response } from "express";
import { RequestWithPayload } from "../../../shared/types";
import {
  getAllAvailableCategories,
  getHomeProducts,
  getMaxPriceRanges,
  getProductsByFilters,
  getProductsForProductOwner,
} from "../services/productsService";
import { getProductOwnersBySearch } from "../services/productOwnerService";

export const getHomeProductsHandler = async (
  req: RequestWithPayload<undefined, { id: string }>,
  res: Response
) => {
  try {
    const userId = req.params.id as string;

    const response = await getHomeProducts(userId);

    res.status(200).json({ message: "Home products found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching products",
      error: error.message,
    });
  }
};

export const getProductsByFiltersHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const response = await getProductsByFilters(req.query);

    res
      .status(200)
      .json({ message: "Products found for search", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching products for search",
      error: error.message,
    });
  }
};
export const getProductRangesHandler = async (req: Request, res: Response) => {
  try {
    const response = await getMaxPriceRanges();

    res
      .status(200)
      .json({ message: "Max price ranges found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching max price ranges",
      error: error.message,
    });
  }
};

export const getProductsCategoriesHandler = async (
  req: Request,
  res: Response
) => {
  try {
    const response = await getAllAvailableCategories();

    res
      .status(200)
      .json({ message: "Available categories found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching available categories",
      error: error.message,
    });
  }
};

export const getProductOwnersHandler = async (req: Request, res: Response) => {
  try {
    const search = req.query.search as string;
    const limit = req.query.limit;
    const offset = req.query.offset;

    const response = await getProductOwnersBySearch(
      +(limit ?? 10),
      +(offset ?? 0),
      search
    );

    res.status(200).json({
      message: `Owners found for search ${search}`,
      content: response,
    });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching product owners",
      error: error.message,
    });
  }
};

export const getProductsForProductOwnerHandler = async (
  req: RequestWithPayload<undefined, { id: string }>,
  res: Response
) => {
  try {
    const ownerId = req.params.id as string;
    const limit = req.query.limit;
    const offset = req.query.offset;

    const response = await getProductsForProductOwner(
      ownerId,
      +(limit ?? 10),
      +(offset ?? 0)
    );

    res.status(200).json({
      message: `Productsfound for product owner with id ${ownerId}`,
      content: response,
    });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message:
        "Something went wrong when fetching products for product owner with id " +
        req.params.id,
      error: error.message,
    });
  }
};
