import { fetchPartnersByRegex } from "../../../models/partnerModel";
import { IPartner } from "../../../shared/types";

export const getPartnersBySearch = async (
  limit: number,
  offset: number,
  regex?: string
) => {
  // if empty string it will fetch all partners
  const foundOwners = await fetchPartnersByRegex(regex ?? "", limit, offset);

  return foundOwners.rows as IPartner[];
};
