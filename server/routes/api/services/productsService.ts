import {
  fetchAffordableProducts,
  fetchMaxPriceRanges,
  fetchNearlyAfforableProducts,
} from "../../../models/productModel";
import { fetchUserById } from "../../../models/userModel";
import { IProduct } from "../../../shared/types";

export const getAffordableProducts = async (
  userId: string,
  limit: number,
  offset: number
) => {
  const foundUser = await fetchUserById(userId);

  if (!foundUser.rowCount || foundUser.rowCount === 0) {
    throw new Error("User not found for id");
  }

  const foundProducts = await fetchAffordableProducts(
    foundUser.rows[0].points,
    limit,
    offset
  );

  if (foundProducts.rowCount && foundProducts.rowCount > 0)
    return {
      products: foundProducts.rows.map((item) => ({
        ...item,
        is_affordable: true,
      })) as IProduct[],
      points: foundUser.rows[0].points,
    };
  else {
    return {
      products: [],
      points: foundUser.rows[0].points,
    };
  }
};

export const getNearlyAffordableProducts = async (userPoints: number) => {
  const foundProducts = await fetchNearlyAfforableProducts(userPoints);

  if (foundProducts.rowCount && foundProducts.rowCount > 0)
    return foundProducts.rows.map((item) => ({
      ...item,
      is_affordable: false,
    })) as IProduct[];
  else {
    return [];
  }
};

export const getHomeProducts = async (userId: string) => {
  // static limit for home products
  const { products: affordable, points } = await getAffordableProducts(
    userId,
    10,
    0
  );
  const nearly_affordable = await getNearlyAffordableProducts(points);

  return { affordable, nearly_affordable };
};

export const getMaxPriceRanges = async () => {
  const response = await fetchMaxPriceRanges();

  if (response.rowCount && response.rowCount > 0)
    return {
      max_price: response.rows[0].max_price,
      max_finpoints: response.rows[0].max_finpoints_price,
    };
  else {
    return {
      max_price: 1000,
      max_finpoints: 1000000,
    };
  }
};
