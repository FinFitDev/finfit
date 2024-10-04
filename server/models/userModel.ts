import { pool } from "../shared/utils/db";

export const fetchAllUsers = async (limit: number, offset: number) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, updated_at FROM users LIMIT $1 OFFSET $2",
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
    "SELECT id, username, email, image, created_at, points, updated_at FROM users u WHERE LIKE(u.username, $1) OR LIKE(u.email, $1) LIMIT $2 OFFSET $3",
    [regex, limit, offset]
  );

  return response;
};

export const fetchUserById = async (id: number) => {
  const response = await pool.query(
    "SELECT id, username, email, image, created_at, points, updated_at FROM users WHERE users.id = $1",
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

export const updatePointsScore = async (
  user_id: number,
  points: number,
  updated_at: string
) => {
  const response = await pool.query(
    "UPDATE users SET points = $1, updated_at = $2 WHERE id = $3;",
    [points, updated_at, user_id]
  );

  return response;
};
