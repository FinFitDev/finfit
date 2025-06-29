import { Request, Response } from "express";
import { addTrainings, getUserTrainings } from "../services/activityService";
import { RequestWithPayload } from "../../../shared/types/general";

export const getTrainingsForUserIdHadler = async (
  req: RequestWithPayload<undefined, { id: string }>,
  res: Response
) => {
  try {
    const userId = req.params.id;
    const limit = req.query.limit;
    const offset = req.query.offset;
    const response = await getUserTrainings(
      userId,
      limit ? +limit : undefined,
      offset ? +offset : undefined
    );

    res.status(200).json({ message: "Trainings found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when getting user trainings",
      error: error.message,
    });
  }
};

export const addTrainingsHandler = async (req: Request, res: Response) => {
  try {
    const trainings = JSON.parse(req.body.trainings);
    const response = await addTrainings(trainings);
    res.status(200).json({ message: "Trainings added", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when adding trainings",
      error: error.message,
    });
  }
};
