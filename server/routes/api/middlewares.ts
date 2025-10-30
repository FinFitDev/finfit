import jwt from "jsonwebtoken";
import "dotenv/config";
import { Request, Response, NextFunction } from "express";

export const apiMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const auth_header = req.headers["authorization"];

  if (!auth_header)
    return res.status(401).json({ error: "You are not authorized" });

  const token = auth_header.split(" ")[1];

  if (token == process.env.SECURITY_TOKEN) return next();

  jwt.verify(token, process.env.JWT_SECRET as string, (err, data) => {
    if (err) {
      return res.status(403).json({ error: "Token invalid or expired" });
    }
    (req as any).userId = (data as any)?.user_id;
    next();
  });
};

export const shopMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Not authorized (missing token)" });
  }

  const token = authHeader.split(" ")[1];

  if (token === process.env.SECURITY_TOKEN) {
    return next();
  }

  jwt.verify(token, process.env.JWT_SECRET as string, (err, data) => {
    if (err) {
      return res.status(403).json({ error: "Token invalid or expired" });
    }

    (req as any).shopId = data;
    next();
  });
};
