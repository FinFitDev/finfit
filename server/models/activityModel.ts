import {
  IDailyStepEntry,
  IHourlyStepEntry,
  ITrainingEntry,
} from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchUserTrainings = async (
  user_id: string,
  limit?: number,
  offset?: number
) => {
  const response = await pool.query(
    `SELECT * 
    FROM trainings 
    WHERE trainings.user_id = $3 
    ORDER BY trainings.created_at DESC 
    LIMIT $1 OFFSET $2`,
    [limit, offset, user_id]
  );
  return response;
};

// fetch trainings 7 days back - first fetch
export const fetchRecentUserTrainings = async (user_id: string) => {
  const response = await pool.query(
    `SELECT * 
    FROM trainings 
    WHERE trainings.user_id = $1 AND trainings.created_at >= NOW() - INTERVAL '7 days'
    ORDER BY trainings.created_at DESC`,
    [user_id]
  );
  return response;
};

export const insertTraining = async ({
  points,
  duration,
  calories,
  distance,
  type,
  user_id,
  uuid,
  created_at,
}: ITrainingEntry) => {
  const response = await pool.query(
    `INSERT INTO trainings (type, points, duration, calories, distance, user_id, uuid, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      ON CONFLICT (uuid) DO NOTHING`,
    [type, points, duration, calories, distance, user_id, uuid, created_at]
  );

  // determine if the entry has been added, or ommited
  return { [uuid]: (response.rowCount ?? 0) > 0 };
};

export const insertNewTrainingsPointsUpdateTransaction = async (
  trainings: ITrainingEntry[],
  userId: string
) => {
  const client = await pool.connect();

  try {
    // Start transaction
    await client.query("BEGIN");

    // Build the VALUES clause dynamically for bulk insert
    const values: any[] = [];
    const placeholders = trainings
      .map((training, index) => {
        const offset = index * 8; // Number of fields in the row
        values.push(
          training.type,
          training.points,
          training.duration,
          training.calories,
          training.distance,
          userId,
          training.uuid,
          training.created_at
        );
        return `($${offset + 1}, $${offset + 2}, $${offset + 3}, $${
          offset + 4
        }, $${offset + 5}, $${offset + 6}, $${offset + 7}, $${offset + 8})`;
      })
      .join(", ");

    // Insert trainings and retrieve the points of successfully inserted rows
    const insertResult = await client.query(
      `
      WITH inserted_rows AS (
        INSERT INTO trainings (type, points, duration, calories, distance, user_id, uuid, created_at)
        VALUES ${placeholders}
        ON CONFLICT (uuid) DO NOTHING
        RETURNING points
      )
      SELECT COALESCE(SUM(points), 0) AS total_added_points FROM inserted_rows;
    `,
      values
    );

    const totalAddedPoints = insertResult.rows[0].total_added_points;

    // Update the user's points
    await client.query(
      `
      UPDATE users
      SET points = points + $1
      WHERE uuid = $2;
    `,
      [totalAddedPoints, userId]
    );

    // Commit the transaction
    await client.query("COMMIT");

    // Return the total added points
    return totalAddedPoints;
  } catch (err) {
    // Rollback the transaction on error
    await client.query("ROLLBACK");
    console.error("Error adding trainings and updating user:", err);
    throw err;
  } finally {
    // Release the client back to the pool
    client.release();
  }
};

// --------------------------------------- DEPRECATED --------------------------------------- //

export const insertHourlySteps = async ({
  uuid,
  user_id,
  timestamp,
  total,
}: IHourlyStepEntry) => {
  const response = await pool.query(
    `INSERT INTO hourly_steps (uuid, timestamp, total, user_id)
      VALUES ($1, $2, $3, $4)
      ON CONFLICT (uuid) DO NOTHING`,
    [uuid, timestamp, total, user_id]
  );

  // determine if the entry has been added, or ommited
  return { [uuid]: (response.rowCount ?? 0) > 0 };
};

// select values which we should aggregate into the daily_steps table
export const extractExpiredHourlySteps = async (
  timestamp: Date,
  user_id: string
) => {
  const response = await pool.query(
    `SELECT * 
    FROM hourly_steps 
    WHERE DATE(timestamp) < DATE($1) AND user_id = $2`,
    [timestamp, user_id]
  );

  return response;
};

export const deleteHourlySteps = async (uuids: string[]) => {
  const response = await pool.query(
    `DELETE FROM hourly_steps
      WHERE uuid = ANY($1::TEXT[])`,
    [uuids]
  );

  return response;
};

export const insertDailySteps = async ({
  uuid,
  user_id,
  timestamp,
  total,
  mean,
}: IDailyStepEntry) => {
  const response = await pool.query(
    `INSERT INTO daily_steps (uuid, timestamp, total, mean, user_id)
      VALUES ($1, $2, $3, $4, $5)
      ON CONFLICT (uuid) 
      DO UPDATE 
      SET total = daily_steps.total + EXCLUDED.total, 
          mean = (daily_steps.total + EXCLUDED.total) / 24.0`,
    [uuid, timestamp, total, mean, user_id]
  );

  // determine if the entry has been added, or ommited
  return { [uuid]: (response.rowCount ?? 0) > 0 };
};

// select values which we should aggregate into the monthly_steps table
export const extractExpiredDailySteps = async (
  timestamp: Date,
  user_id: string
) => {
  const response = await pool.query(
    `SELECT *
      FROM daily_steps
      WHERE
      (EXTRACT(YEAR FROM timestamp) < EXTRACT(YEAR FROM $1::timestamp) OR
        (
          EXTRACT(YEAR FROM timestamp) = EXTRACT(YEAR FROM $1::timestamp) AND
          EXTRACT(MONTH FROM timestamp) < EXTRACT(MONTH FROM $1::timestamp)
        )
      ) AND user_id = $2`,
    [timestamp, user_id]
  );

  return response;
};

export const deleteDailySteps = async (uuids: string[]) => {
  const response = await pool.query(
    `DELETE FROM daily_steps
      WHERE uuid = ANY($1::TEXT[])`,
    [uuids]
  );

  return response;
};
//     `INSERT INTO trainings (uuid, points, duration, calories, distance, type, user_id, created_at)
// SELECT new.uuid, new.points, new.duration, new.calories, new.distance, new.type, new.user_id, new.created_at
// FROM (VALUES
//     (12345, 100, 30, 200, 2.5, 'run', 1, '2025-01-01T12:00:00Z'),
//     (12346, 200, 60, NULL, NULL, 'bike', 1, NULL)
// ) AS new(uuid, points, duration, calories, distance, type, user_id, created_at)
// WHERE NOT EXISTS (
//     SELECT 1 FROM trainings WHERE trainings.uuid = new.uuid
// );`
