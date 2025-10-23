import { QueryResult } from "pg";
import { ErrorWithCode } from "../../exceptions/errorWithCode";
import {
  fetchRecentUserTrainings,
  fetchUserTrainings,
  insertTraining,
  insertTrainingsBulk,
} from "../../models/activityModel";
import { ONE_DAY_MILLISECONDS } from "../../shared/constants";
import {
  IDailyStepEntry,
  IHourlyStepEntry,
  ITrainingEntry,
  ITrainingEntryResponse,
} from "../../shared/types";
import { aggregateDailyDataObject } from "../../shared/utils";
import { pool } from "../../shared/utils/db";
import { updatePointsScore } from "../../models/userModel";

export const getUserTrainings = async (
  userId: string,
  limit?: number,
  offset?: number
) => {
  // Fetch recent trainings if no offset or offset is 0
  let foundTrainings =
    !offset || offset === 0
      ? await fetchRecentUserTrainings(userId)
      : undefined;

  // If offset exists or we need more data based on row count
  if (offset || (foundTrainings?.rowCount ?? 0) < (limit ?? 0)) {
    const local = await fetchUserTrainings(
      userId,
      (limit ?? 0) - (foundTrainings?.rowCount ?? 0),
      (offset ?? 0) + (foundTrainings?.rowCount ?? 0)
    );
    foundTrainings = foundTrainings
      ? {
          ...foundTrainings,
          rows: [...foundTrainings.rows, ...local.rows],
          rowCount: (foundTrainings.rowCount ?? 0) + (local.rowCount ?? 0),
        }
      : local;
  }

  return foundTrainings?.rows as ITrainingEntryResponse[];
};

export const addTrainings = async (trainings: string[]) => {
  if (!trainings.length) {
    return "0";
  }
  const parsedTrainings: ITrainingEntry[] = trainings.map((training) =>
    JSON.parse(training)
  );
  const userId = parsedTrainings[0].user_id;
  const client = await pool.connect();

  try {
    // Start transaction
    await client.query("BEGIN");

    const values: any[] = [];
    const placeholders = parsedTrainings
      .map((training, index) => {
        const offset = index * 10;
        values.push(
          training.type,
          training.points,
          training.duration,
          training.calories,
          training.distance,
          userId,
          training.created_at,
          training.strava_id,
          training.polyline,
          training.elevation_change
        );
        return `($${offset + 1}, $${offset + 2}, $${offset + 3}, $${
          offset + 4
        }, $${offset + 5}, $${offset + 6}, $${offset + 7},$${offset + 8}, $${
          offset + 9
        }, $${offset + 10})`;
      })
      .join(", ");

    // Insert trainings and retrieve the points of successfully inserted rows
    const insertResult = await insertTrainingsBulk(
      values,
      placeholders,
      client
    );

    const totalAddedPoints = insertResult.rows[0].total_added_points;

    await updatePointsScore(userId, totalAddedPoints, client);

    await client.query("COMMIT");

    return totalAddedPoints;
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error adding trainings and updating user:", err);
    throw err;
  } finally {
    client.release();
  }
};
