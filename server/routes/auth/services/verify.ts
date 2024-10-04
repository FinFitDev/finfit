import jwt from "jsonwebtoken";

export const verifyAccessToken = (access_token: string) => {
  return new Promise((resolve, reject) => {
    jwt.verify(access_token, process.env.JWT_SECRET as string, (err, data) => {
      if (err) reject("Token invalid or expired");
      else if (data) resolve(data);
    });
  });
};
