import {
  fetchAffordableProducts,
  fetchAllAvailableCategories,
  fetchMaxPriceRanges,
  fetchNearlyAfforableProducts,
  fetchProducts,
  fetchProductsByFilters,
  fetchProductsForProductOwner,
} from "../../../models/productModel";
import { fetchUserById } from "../../../models/userModel";
import { IFiltersQuery, IProduct } from "../../../shared/types/shop";

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
    5,
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

export const getAllAvailableCategories = async () => {
  const response = await fetchAllAvailableCategories();

  return response.rows;
};

export const getProductsByFilters = async (query: IFiltersQuery) => {
  // if empty string it will fetch all products
  const foundProducts = await fetchProductsByFilters(query);
  if (foundProducts.rowCount && foundProducts.rowCount > 0) {
    return foundProducts.rows as IProduct[];
  } else {
    return [];
  }
};

export const getProductsForProductOwner = async (
  owner_id: string,
  limit: number,
  offset: number
) => {
  const foundProducts = await fetchProductsForProductOwner(
    owner_id,
    limit,
    offset
  );

  if (foundProducts.rowCount && foundProducts.rowCount > 0)
    return foundProducts.rows as IProduct[];
  else {
    return [];
  }
};
