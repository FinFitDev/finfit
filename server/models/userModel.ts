import { pool } from "../shared/utils/db";

export const fetchAllUsers = async (limit: number, offset: number) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, steps_updated_at FROM users LIMIT $1 OFFSET $2",
    [limit, offset]
  );

  return response;
};

export const fetchUsersByRegex = async (
  regex: string,
  limit: number,
  offset: number
) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, steps_updated_at FROM users u WHERE LIKE(u.username, $1) OR LIKE(u.email, $1) LIMIT $2 OFFSET $3",
    [regex, limit, offset]
  );

  return response;
};

export const fetchUserById = async (id: number) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, steps_updated_at FROM users WHERE users.id = $1",
    [id]
  );

  return response;
};

export const insertUser = async (
  username: string,
  email: string,
  password: string
) => {
  const response = await pool.query(
    "INSERT INTO users (username, email, password) VALUES ($1, $2, $3)",
    [username, email, password]
  );

  return response;
};

export const insertGoogleAuthUser = async (
  username: string,
  email: string,
  google_id: string,
  image?: string
) => {
  const response = await pool.query(
    "INSERT INTO users (username, email, google_id, image) VALUES ($1, $2, $3, $4)",
    [username, email, google_id, image]
  );

  return response;
};

export const fetchUserByUsername = async (username: string) => {
  const response = await pool.query(
    "SELECT * FROM users WHERE users.username = $1",
    [username]
  );

  return response;
};

export const fetchUserByEmail = async (email: string) => {
  const response = await pool.query(
    "SELECT * FROM users WHERE users.email = $1",
    [email]
  );

  return response;
};

export const fetchUserByUsernameOrEmail = async (login: string) => {
  const response = await pool.query(
    "SELECT * FROM users WHERE users.email = $1 OR users.username = $1",
    [login]
  );

  return response;
};

export const updatePointsScore = async (user_id: number, points: number) => {
  const response = await pool.query(
    "UPDATE users SET points = points + $1 WHERE id = $2;",
    [points, user_id]
  );

  return response;
};

export const updatePointsScoreWithUpdateTimestamp = async (
  user_id: number,
  points: number,
  steps_updated_at: string
) => {
  const response = await pool.query(
    "UPDATE users SET points = points + $1, steps_updated_at = $2 WHERE id = $3;",
    [points, steps_updated_at, user_id]
  );

  return response;
};
