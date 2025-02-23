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
  const formattedRegex = `%${regex.toLowerCase()}%`;

  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, steps_updated_at FROM users u WHERE LOWER(u.username) LIKE $1 LIMIT $2 OFFSET $3",
    [formattedRegex, limit, offset]
  );
  return response;
};

export const fetchUserById = async (id: string) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, steps_updated_at FROM users WHERE users.id = $1",
    [id]
  );

  return response;
};

export const insertUser = async (
  id: string,
  username: string,
  email: string,
  password: string,
  image: string
) => {
  const response = await pool.query(
    "INSERT INTO users (id, username, email, password, image) VALUES ($1, $2, $3, $4, $5)",
    [id, username, email, password, image]
  );

  return response;
};

export const insertGoogleAuthUser = async (
  id: string,
  username: string,
  email: string,
  google_id: string,
  image: string
) => {
  const response = await pool.query(
    "INSERT INTO users (id, username, email, google_id, image) VALUES ($1, $2, $3, $4, $5)",
    [id, username, email, google_id, image]
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

export const updatePointsScore = async (user_id: string, points: number) => {
  const response = await pool.query(
    "UPDATE users SET points = points + $1 WHERE id = $2;",
    [points, user_id]
  );

  return response;
};

export const updatePointsScoreWithUpdateTimestamp = async (
  user_id: string,
  points: number,
  steps_updated_at: string
) => {
  const response = await pool.query(
    "UPDATE users SET points = points + $1, steps_updated_at = $2 WHERE id = $3;",
    [points, steps_updated_at, user_id]
  );

  return response;
};
