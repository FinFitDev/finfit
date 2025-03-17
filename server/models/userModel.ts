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
    "SELECT id, username, email, image, created_at, points, steps_updated_at, verified FROM users WHERE users.id = $1",
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
    "INSERT INTO users (id, username, email, google_id, image, verified) VALUES ($1, $2, $3, $4, $5, $6)",
    // the user is verified if google verified the email
    [id, username, email, google_id, image, true]
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

export const updateImageSeed = async (user_id: string, image: string) => {
  const response = await pool.query(
    "UPDATE users SET image = $1 WHERE id = $2;",
    [image, user_id]
  );

  return response;
};

export const updateVerifyUser = async (user_id: string) => {
  const response = await pool.query(
    "UPDATE users SET verified = $1 WHERE id = $2;",
    [true, user_id]
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

export const transferPointsTransaction = async (
  userId: string,
  recipientsIds: string[],
  totalAmount: number,
  fractionAmount: number
) => {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    const remainingPoints = await client.query(
      `
        WITH users AS (
          UPDATE users
          SET points = points - $1
          WHERE id = $2
          RETURNING points
        )
        SELECT points FROM users
      `,
      [Math.round(totalAmount), userId]
    );

    const userRemainingPoints = remainingPoints.rows[0]?.points;

    if (userRemainingPoints < 0) {
      await client.query("ROLLBACK");
      throw new Error("Not enough points for the transaction.");
    }

    for (const recipientId of recipientsIds) {
      await client.query(
        `
          UPDATE users
          SET points = points + $1
          WHERE id = $2
        `,
        [fractionAmount, recipientId]
      );
    }

    await client.query("COMMIT");

    return userRemainingPoints;
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error transferring points:", err);
    throw err;
  } finally {
    client.release();
  }
};
