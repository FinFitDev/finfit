import { ErrorWithCode } from "../../exceptions/errorWithCode";
import {
  fetchUserByEmail,
  fetchUserById,
  fetchUsersByIds,
  fetchUsersByRegex,
  transferPointsTransaction,
  updateImageSeed,
  updatePointsScore,
  updatePointsScoreWithUpdateTimestamp,
} from "../../models/userModel";
import { IUserNoPassword } from "../../shared/types";

export const getUserById = async (user_id: string) => {
  const foundUser = await fetchUserById(user_id);

  if (foundUser.rowCount && foundUser.rowCount > 0)
    return foundUser.rows[0] as IUserNoPassword;
  else {
    throw new ErrorWithCode(`No user found with id ${user_id}`, 404);
  }
};

export const getUsersByIds = async (user_ids: string[]) => {
  const foundUser = await fetchUsersByIds(user_ids);

  if (foundUser.rowCount && foundUser.rowCount > 0)
    return foundUser.rows as IUserNoPassword[];
  else {
    throw new ErrorWithCode(
      `No user found with ids ${user_ids.join(", ")}`,
      404
    );
  }
};

export const getUsersBySearch = async (
  search: string,
  limit: number,
  offset: number
) => {
  const foundUsers = await fetchUsersByRegex(search, limit, offset);

  if (foundUsers.rowCount && foundUsers.rowCount > 0)
    return foundUsers.rows as IUserNoPassword[];
  else {
    throw new ErrorWithCode(`No users found with search ${search}`, 404);
  }
};

export const updateUserImage = async (user_id: string, image: string) => {
  const response = await updateImageSeed(user_id, image);
  return response.command;
};

export const updateUserPointsScore = async (
  user_id: string,
  points: number
) => {
  const response = await updatePointsScore(user_id, points);
  return response.command;
};

export const updateUserPointsScoreWithUpdateTimestamp = async (
  user_id: string,
  points: number,
  steps_updated_at: string
) => {
  const response = await updatePointsScoreWithUpdateTimestamp(
    user_id,
    points,
    steps_updated_at
  );
  return response.command;
};

export const transferPointsToOtherUsers = async (
  user_id: string,
  recipients_ids: string[],
  amount: number
) => {
  const totalRecipients = recipients_ids.length;
  const fractionAmount = Math.round(amount / totalRecipients);

  if (!amount || amount <= 0) {
    throw new Error("Invalid amount to send");
  }

  const response = await transferPointsTransaction(
    user_id,
    recipients_ids,
    amount,
    fractionAmount
  );

  return response;
};
