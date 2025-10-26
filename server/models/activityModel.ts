import { PoolClient } from "pg";
import { ITrainingEntry } from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchUserTrainings = async (
  user_id: string,
  limit?: number,
  offset?: number
) => {
  const response = await pool.query(
    `SELECT * 
    FROM trainings 
    WHERE trainings.user_id = $3 AND trainings.points > 0
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
    WHERE trainings.user_id = $1 AND trainings.created_at >= NOW() - INTERVAL '7 days' AND trainings.points > 0
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
  created_at,
  strava_id,
  polyline,
  elevation_change,
  average_speed,
}: ITrainingEntry) => {
  const response = await pool.query(
    `INSERT INTO trainings (type, points, duration, calories, distance, user_id, created_at, strava_id, polyline, elevation_change, average_speed)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
`,
    [
      type,
      points,
      duration,
      calories,
      distance,
      user_id,
      created_at,
      strava_id,
      polyline,
      elevation_change,
      average_speed,
    ]
  );

  return response;
};

export const insertTrainingsBulk = async (
  values: string[],
  placeholders: string,
  client?: PoolClient
) => {
  const executor = client ?? pool;
  const insertResult = await executor.query(
    `
     WITH inserted_rows AS (
        INSERT INTO trainings (
          type, points, duration, calories, distance, user_id, created_at, strava_id, polyline, elevation_change, average_speed
        )
        VALUES ${placeholders}
        RETURNING id, points
      )
      SELECT array_agg(id) AS inserted_ids, COALESCE(SUM(points), 0) AS total_added_points
      FROM inserted_rows;
    `,
    values
  );

  return insertResult;
};

export const updateStravaTraining = async (type: string, strava_id: number) => {
  const response = await pool.query(
    `UPDATE trainings SET type = $1 WHERE strava_id = $2
`,
    [type, strava_id]
  );

  return response;
};
