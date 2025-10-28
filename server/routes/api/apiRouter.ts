import express, { Router } from "express";
import {
  getUserByIdHandler,
  getUsersHandler,
  sendPointsHandler,
  updateStravaPermissions,
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

apiRouter.put("/users/strava/enabled/:id", updateStravaPermissions);

apiRouter.get("/trainings/:id", getTrainingsForUserIdHadler);

apiRouter.post("/trainings", addTrainingsHandler);

apiRouter.get("/offers/featured", getFeaturedOffersHandler);

apiRouter.get("/offers", getOffersHandler);

apiRouter.post("/offers/claim/:id", claimDiscountHandler);

apiRouter.get("/claims/:id", getAllClaimsHandler);

apiRouter.post("/transactions", addTransactionsHandler);

apiRouter.get("/transactions/:user_id", getTransactionsHandler);

export default apiRouter as Router;
