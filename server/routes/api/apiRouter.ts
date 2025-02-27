import express, { Request, Response, Router } from "express";
import {
  getUserById,
  getUsersBySearch,
  transferPointsToOtherUsers,
  updateUserPointsScore,
  updateUserPointsScoreWithUpdateTimestamp,
} from "./services/userService";
import { RequestWithPayload } from "../../shared/types";
import {
  addStepsData,
  addTrainings,
  getUserRecentTrainings,
} from "./services/activityService";

const apiRouter: Router = express.Router();

apiRouter.get(
  "/users/:id",
  async (req: RequestWithPayload<undefined, { id: string }>, res: Response) => {
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
  }
);

apiRouter.post(
  "/users/:id",
  async (
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
  }
);

apiRouter.get(
  "/users",
  async (req: RequestWithPayload<undefined>, res: Response) => {
    try {
      const search = req.query.search as string;
      const limit = req.query.limit as string;
      const offset = req.query.offset as string;
      const response = await getUsersBySearch(search, +limit, +offset);

      res.status(200).json({ message: "Users found", content: response });
    } catch (error: any) {
      res.status(error.statusCode ?? 404).json({
        message: "Something went wrong when fetching users",
        error: error.message,
      });
    }
  }
);

apiRouter.post("/users/send/:id", async (req: Request, res: Response) => {
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
});

apiRouter.get(
  "/trainings/:id",
  async (req: RequestWithPayload<undefined, { id: string }>, res: Response) => {
    try {
      const user_id = req.params.id;
      const limit = req.query.limit;
      const offset = req.query.offset;
      const response = await getUserRecentTrainings(
        user_id,
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
  }
);

apiRouter.post("/trainings", async (req: Request, res: Response) => {
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
});

apiRouter.get(
  "/steps/:id",
  async (req: RequestWithPayload<undefined, { id: string }>, res: Response) => {
    try {
      const user_id = req.params.id;
      const limit = req.query.limit;
      const offset = req.query.offset;
      const response = await getUserRecentTrainings(
        user_id,
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
  }
);

apiRouter.post("/steps", async (req: Request, res: Response) => {
  try {
    const steps = JSON.parse(req.body.steps);
    const response = await addStepsData(steps);
    res
      .status(200)
      .json({ message: "Steps added and aggregated", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when adding or aggregating steps data",
      error: error.message,
    });
  }
});

export default apiRouter as Router;
