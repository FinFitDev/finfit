import express, { Request, Response, Router } from "express";
import { getUserById, updateUserPointsScore } from "./services/userService";
import { RequestWithPayload } from "../../shared/types";

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

apiRouter.post("/users/:id", async (req: Request, res: Response) => {
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

export default apiRouter as Router;
