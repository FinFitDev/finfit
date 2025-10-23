import {
  IUserStravaInsertPayload,
  IUserStravaRefreshPayload,
} from "../shared/types/strava";
import { pool } from "../shared/utils/db";

export const insertStravaCredentials = async ({
  userId,
  athleteId,
  accessToken,
  refreshToken,
  tokenExpiresIn,
}: IUserStravaInsertPayload) => {
  const expiresAt = new Date(Date.now() + +tokenExpiresIn * 1000);
  const response = await pool.query(
    "INSERT INTO users_strava (user_id, athlete_id, access_token, refresh_token, token_expires_at) VALUES ($1, $2, $3, $4, $5)",
    [userId, athleteId, accessToken, refreshToken, expiresAt]
  );

  return response;
};

export const updateStravaTokens = async ({
  userId,
  accessToken,
  refreshToken,
  tokenExpiresIn,
}: IUserStravaRefreshPayload) => {
  const expiresAt = new Date(Date.now() + +tokenExpiresIn * 1000);

  const response = await pool.query(
    "UPDATE users_strava SET access_token = $1, refresh_token = $2, token_expires_at = $3 WHERE user_id = $4",
    [accessToken, refreshToken, expiresAt, userId]
  );

  return response;
};

export const getStravaAccessToken = async (userId: string) => {
  const response = await pool.query(
    "SELECT access_token FROM users_strava WHERE user_id = $1",
    [userId]
  );

  return response;
};

export const getStravaUserInfoByAthleteId = async (athleteId: number) => {
  const response = await pool.query(
    "SELECT * FROM users_strava WHERE athlete_id = $1",
    [athleteId]
  );

  return response;
};
