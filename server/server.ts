import express, { Express } from "express";
import "dotenv/config";
import bodyParser from "body-parser";
import cors from "cors";
import authRouter from "./routes/auth/authRouter";
import apiRouter from "./routes/api/apiRouter";
import webhookRouter from "./routes/webhook";

import { middleware } from "./routes/api/middleware";
import stravaRouter from "./routes/stravaRouter";
import { encrypt } from "./shared/utils/encryption";

const app: Express = express();
app.use(cors());

// const pool = require("./utils/db");

const port = process.env.PORT || "3000";

// console.log(crypto.randomBytes(64).toString("hex"));

app.use((req, res, next) => {
  if (req.originalUrl === "/webhook/woocommerce") return next();

  bodyParser.urlencoded({ extended: true, limit: "50mb" })(req, res, (err) => {
    if (err) return next(err);
    bodyParser.json({ limit: "50mb" })(req, res, next);
  });
});

app.use("/auth", authRouter);
app.use("/webhook", webhookRouter);
app.use("/strava", stravaRouter);
app.use("/api/v1", middleware, apiRouter);

app.listen(port, () => {
  console.log("App running on port 3000");
});
