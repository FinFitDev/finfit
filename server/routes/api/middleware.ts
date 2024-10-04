import jwt from "jsonwebtoken";
import "dotenv/config";
import { Request, Response, NextFunction } from "express";
import { RequestWithPayload } from "../../shared/types";

export const middleware = (req: Request, res: Response, next: NextFunction) => {
  const auth_header = req.headers["authorization"];

  if (!auth_header)
    return res.status(401).json({ error: "You are not authorized" });

  const token = auth_header.split(" ")[1];

  if (token == process.env.SECURITY_TOKEN) return next();

  jwt.verify(token, process.env.JWT_SECRET as string, (err, data) => {
    if (err) return res.status(403).json({ error: "Token invalid or expired" });

    (req as any).user = data;
    next();
  });
};
