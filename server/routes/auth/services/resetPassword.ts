import { fetchUserByEmail } from "../../../models/userModel";

export const getUserByEmail = async (email: string) => {
  if (!email) {
    throw new Error("No email provided");
  }

  const foundUser = await fetchUserByEmail(email);

  return !!(foundUser.rowCount && foundUser.rowCount > 0);
};
