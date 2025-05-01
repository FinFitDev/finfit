import { fetchProductOwnersByRegex } from "../../../models/productOwnerModel";
import { IProductOwner } from "../../../shared/types";

export const getProductOwnersBySearch = async (
  limit: number,
  offset: number,
  regex?: string
) => {
  // if empty string it will fetch all owners
  const foundOwners = await fetchProductOwnersByRegex(
    regex ?? "",
    limit,
    offset
  );

  return foundOwners.rows as IProductOwner[];
};
