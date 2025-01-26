import {
  IDailyStepEntry,
  IHourlyStepEntry,
  ITrainingEntry,
} from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchRecentUserTrainings = async (
  user_id: number,
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
  user_id: number
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
  user_id: number
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
