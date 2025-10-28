import {
  fetchAffordableOffers,
  fetchFeaturedOffers,
  fetchPaginatedOffers,
} from "../../models/offersModel";
import { fetchUserById } from "../../models/userModel";
import { IOffer } from "../../shared/types";

export const getOffers = async (
  search: string,
  limit: number,
  offset: number
) => {
  const foundOffers = await fetchPaginatedOffers(search, limit, offset);
  return foundOffers.rows as IOffer[];
};

export const getAffordableOffers = async (
  userId: string,
  limit: number,
  offset: number
) => {
  const foundUser = await fetchUserById(userId);

  if (!foundUser.rowCount || foundUser.rowCount === 0) {
    throw new Error("User not found for id");
  }

  const foundOffers = await fetchAffordableOffers(
    foundUser.rows[0].points,
    limit,
    offset
  );

  if (foundOffers.rowCount && foundOffers.rowCount > 0)
    return {
      products: foundOffers.rows as IOffer[],
      points: foundUser.rows[0].points,
    };
  else {
    return {
      products: [],
      points: foundUser.rows[0].points,
    };
  }
};

export const getFeaturedOffers = async (limit: number, offset: number) => {
  const foundOffers = await fetchFeaturedOffers(limit, offset);
  return foundOffers.rows as IOffer[];
};
