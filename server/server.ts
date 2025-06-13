import express, { Express } from "express";
import "dotenv/config";
import bodyParser from "body-parser";
import cors from "cors";
import authRouter from "./routes/auth/authRouter";
import apiRouter from "./routes/api/apiRouter";
import { middleware } from "./routes/api/middleware";
import "./routes/api/services/synchronization/synchronizationService";
import bcrypt from "bcryptjs";
import { encrypt } from "./shared/utils";

const app: Express = express();
app.use(cors());

const port = process.env.PORT || "3000";

app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));
app.use(bodyParser.json({ limit: "50mb" }));

// (async () => {
//   const encrypted = encrypt("YVMKB8XBD8M48JD56B46CNHSCS7CX83I");
//   console.log("Hashed passwo:", encrypted);
// })();

app.use("/auth", authRouter);
app.use("/api/v1", middleware, apiRouter);

app.listen(port, () => {
  console.log("App running on port 3000");
});
