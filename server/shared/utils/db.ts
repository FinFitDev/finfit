import { Pool } from "pg";

export const pool: Pool = new Pool({
  connectionString:
    process.env.NODE_ENV === "production"
      ? process.env.DATABASE_URL
      : process.env.DATABASE_URL_DEV,
});
