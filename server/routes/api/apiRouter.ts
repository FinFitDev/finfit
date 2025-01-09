import express, { Request, Response, Router } from "express";
import { getUserById, updateUserPointsScore } from "./services/userService";
import { ITrainingEntry, RequestWithPayload } from "../../shared/types";
import { addTrainings, getUserRecentTrainings } from "./services/activityService";
import { off } from "process";

const apiRouter: Router = express.Router();

apiRouter.get(
  "/users/:id",
  async (req: RequestWithPayload<undefined, { id: number }>, res: Response) => {
    try {
      const user_id = Number(req.params.id);
      const response = await getUserById(user_id);

      res.status(200).json({ message: "User found", content: response });
    } catch (error: any) {
      res.status(error.statusCode ?? 404).json({
        message: "Something went wrong when fetching user",
        error: error.message,
      });
    }
  }
);

apiRouter.post("/users/:id", async (req: RequestWithPayload<{points:number, updated_at:string}, { id: number }>, res: Response) => {
  try {
    const user_id = Number(req.params.id);
    const { points, updated_at } = req.body;
    const response = await updateUserPointsScore(user_id, points, updated_at);

    res
      .status(200)
      .json({ message: "Points score updated", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when updating the point score",
      error: error.message,
    });
  }
});

apiRouter.get('/trainings/:id', async (req: RequestWithPayload<undefined, { id: number }>, res: Response) => {
  try {
    const user_id = Number(req.params.id);
    const limit = req.query.limit
    const offset = req.query.offset
    const response = await getUserRecentTrainings(user_id, limit ? +limit : undefined ,  offset ? +offset : undefined);

    res.status(200).json({ message: "Trainings found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when getting user trainings",
      error: error.message,
    });
  }
})

apiRouter.post('/trainings', async (req: Request, res: Response) => {
  try {
    const trainings = JSON.parse(JSON.stringify(req.body.trainings))
    const response = await addTrainings(trainings)
    res
    .status(200)
    .json({ message: "Trainings added", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when adding trainings",
      error: error.message,
    });
  }
})

export default apiRouter as Router;
