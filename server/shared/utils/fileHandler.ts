import fs from "fs";

export const readFile = (path: string) => {
  return fs.readFileSync(path, "utf-8");
};
