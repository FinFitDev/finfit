import { Request, Response } from "express";
import {
  getUserById,
  getUsersByIds,
  getUsersBySearch,
  transferPointsToOtherUsers,
  updateUserImage,
  updateUserPointsScore,
  updateUserPointsScoreWithUpdateTimestamp,
} from "../services/userService";
import { RequestWithPayload } from "../../../shared/types/general";

export const getUserByIdHandler = async (
  req: RequestWithPayload<undefined, { id: string }>,
  res: Response
) => {
  try {
    const user_id = req.params.id;
    const response = await getUserById(user_id);

    res.status(200).json({ message: "User found", content: response });
  } catch (error: any) {
    console.log(error);
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching user",
      error: error.message,
    });
  }
};

export const updateUserPointsScoreHandler = async (
  req: RequestWithPayload<
    { points: number; steps_updated_at?: string },
    { id: string }
  >,
  res: Response
) => {
  try {
    const user_id = req.params.id;
    const { points, steps_updated_at } = req.body;
    let response;
    if (steps_updated_at) {
      // we only update the steps_updated_at when updating steps
      response = await updateUserPointsScoreWithUpdateTimestamp(
        user_id,
        points,
        steps_updated_at
      );
    } else {
      // updating trainings or purchases
      response = await updateUserPointsScore(user_id, points);
    }

    res
      .status(200)
      .json({ message: "Points score updated", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when updating the point score",
      error: error.message,
    });
  }
};

export const updateUserImageHandler = async (
  req: RequestWithPayload<{ image: string }, { id: string }>,
  res: Response
) => {
  try {
    const user_id = req.params.id;
    const { image } = req.body;

    const response = await updateUserImage(user_id, image);

    res.status(200).json({ message: "Image updated", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when updating the image",
      error: error.message,
    });
  }
};

export const getUsersHandler = async (
  req: RequestWithPayload<undefined>,
  res: Response
) => {
  try {
    const search = req.query.search as string;
    const limit = req.query.limit as string;
    const offset = req.query.offset as string;
    const user_ids = req.query.ids
      ? (JSON.parse(req.query.ids as string) as string[])
      : undefined;

    let response;
    if (user_ids?.length) {
      response = await getUsersByIds(user_ids);
    } else {
      response = await getUsersBySearch(search, +limit, +offset);
    }

    res.status(200).json({ message: "Users found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching users",
      error: error.message,
    });
  }
};

export const sendPointsHandler = async (req: Request, res: Response) => {
  try {
    const recipients_ids = req.body.recipients_ids;
    const amount = req.body.amount;
    const user_id = req.params.id;

    const response = await transferPointsToOtherUsers(
      user_id,
      recipients_ids,
      amount
    );

    res.status(200).json({ message: "Points sent", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when sending points",
      error: error.message,
    });
  }
};
