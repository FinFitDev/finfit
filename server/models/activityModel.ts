import { ITrainingEntry } from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchRecentUserTrainings = async (user_id: number,limit?: number, offset?: number) => {
  const response = await pool.query(
    `SELECT * 
    FROM trainings 
    WHERE trainings.user_id = $3 
    ORDER BY trainings.created_at DESC 
    LIMIT $1 OFFSET $2`, [limit, offset, user_id]
  );
  return response;
};

export const insertTraining = async ({ points,
    duration,
    calories,
    distance, type, user_id, uuid, created_at} : ITrainingEntry
  ) => {
    const response = await pool.query(
      `INSERT INTO trainings (type, points, duration, calories, distance, user_id, uuid, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      ON CONFLICT (uuid) DO NOTHING`,
      [type, points, duration, calories, distance, user_id, uuid, created_at]
    );

    // determine if the entry has been added, or ommited
    return {[uuid]: (response.rowCount ?? 0) > 0};
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
  