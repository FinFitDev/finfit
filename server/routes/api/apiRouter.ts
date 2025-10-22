import express, { Router } from "express";
import {
  getUserByIdHandler,
  getUsersHandler,
  sendPointsHandler,
  updateUserImageHandler,
  updateUserPointsScoreHandler,
} from "./routes/userRoute";
import {
  addTrainingsHandler,
  getTrainingsForUserIdHadler,
} from "./routes/trainingsRoute";

import {
  addTransactionsHandler,
  getTransactionsHandler,
} from "./routes/transactionsRoute";
import {
  getFeaturedOffersHandler,
  getOffersHandler,
} from "./routes/offersRoute";
import {
  claimDiscountHandler,
  getAllClaimsHandler,
} from "./routes/claimsRoute";

const apiRouter: Router = express.Router();

apiRouter.get("/users/:id", getUserByIdHandler);

apiRouter.post("/users/points/:id", updateUserPointsScoreHandler);

apiRouter.post("/users/image/:id", updateUserImageHandler);

apiRouter.get("/users", getUsersHandler);

apiRouter.post("/users/send/:id", sendPointsHandler);

apiRouter.get("/trainings/:id", getTrainingsForUserIdHadler);

apiRouter.post("/trainings", addTrainingsHandler);

apiRouter.get("/offers/featured", getFeaturedOffersHandler);

apiRouter.get("/offers", getOffersHandler);

apiRouter.post("/offers/claim/:id", claimDiscountHandler);

apiRouter.get("/claims/:id", getAllClaimsHandler);

// apiRouter.get("/product_ranges", getProductRangesHandler);

// apiRouter.get("/product_categories", getProductsCategoriesHandler);

// apiRouter.get("/product_owners", getProductOwnersHandler);

apiRouter.post("/transactions", addTransactionsHandler);

apiRouter.get("/transactions/:user_id", getTransactionsHandler);
// apiRouter.get(
//   "/steps/:id",
//   async (req: RequestWithPayload<undefined, { id: string }>, res: Response) => {
//     try {
//       const user_id = req.params.id;
//       const limit = req.query.limit;
//       const offset = req.query.offset;
//       const response = await getUserRecentTrainings(
//         user_id,
//         limit ? +limit : undefined,
//         offset ? +offset : undefined
//       );

//       res.status(200).json({ message: "Trainings found", content: response });
//     } catch (error: any) {
//       res.status(error.statusCode ?? 404).json({
//         message: "Something went wrong when getting user trainings",
//         error: error.message,
//       });
//     }
//   }
// );

// apiRouter.post("/steps", async (req: Request, res: Response) => {
//   try {
//     const steps = JSON.parse(req.body.steps);
//     const response = await addStepsData(steps);
//     res
//       .status(200)
//       .json({ message: "Steps added and aggregated", content: response });
//   } catch (error: any) {
//     res.status(error.statusCode ?? 404).json({
//       message: "Something went wrong when adding or aggregating steps data",
//       error: error.message,
//     });
//   }
// });

export default apiRouter as Router;
