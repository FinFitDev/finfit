import {
  getStravaUserInfoByAthleteId,
  insertStravaCredentials,
  updateStravaTokens,
} from "../models/userStravaModel";
import { HTTP_METHOD } from "../shared/types/general";
import {
  IStravaActivityInfoRequest,
  IStravaActivityInfoResponse,
  IStravaAuthResponse,
  IStravaWebhookEvent,
  IStravaWebhookVerificationRequest,
  STRAVA_EVENT_OBJECT_TYPE,
  STRAVA_EVENT_TYPE,
  STRAVA_WEBHOOK_MODE,
} from "../shared/types/strava";
import { fetchHandler } from "../shared/utils/fetching";
import "dotenv/config";
import { addTrainings } from "./api/activityService";
import { ITrainingEntry } from "../shared/types";
import { calculatePoints } from "../shared/utils";
import { updateStravaTraining } from "../models/activityModel";

export const getStravaToken = async (code: string, userId: string) => {
  const response: IStravaAuthResponse = await fetchHandler(
    `https://www.strava.com/api/v3/oauth/token`,
    {
      method: HTTP_METHOD.POST,

      body: {
        client_id: +(process.env.STRAVA_CLIENT_ID ?? ""),
        client_secret: process.env.STRAVA_CLIENT_SECRET ?? "",
        code,
        grant_type: "authorization_code",
      },
    }
  );

  await insertStravaCredentials({
    userId,
    athleteId: response.athlete.id,
    accessToken: response.access_token,
    refreshToken: response.refresh_token,
    tokenExpiresIn: response.expires_in,
  });

  return true;
};

export const refreshStravaToken = async (
  refreshToken: string,
  userId: string
) => {
  const response: IStravaAuthResponse = await fetchHandler(
    `https://www.strava.com/api/v3/oauth/token`,
    {
      method: HTTP_METHOD.POST,

      body: {
        client_id: +(process.env.STRAVA_CLIENT_ID ?? ""),
        client_secret: process.env.STRAVA_CLIENT_SECRET ?? "",
        refresh_token: refreshToken,
        grant_type: "refresh_token",
      },
    }
  );

  await updateStravaTokens({
    userId,
    accessToken: response.access_token,
    refreshToken: response.refresh_token,
    tokenExpiresIn: response.expires_in,
  });

  return { accessToken: response.access_token };
};

export const handleStravaActivityInfo = async ({
  accessToken,
  activityId,
  userId,
}: IStravaActivityInfoRequest) => {
  const response: IStravaActivityInfoResponse = await fetchHandler(
    `https://www.strava.com/api/v3/activities/${activityId}`,
    {
      method: HTTP_METHOD.GET,
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    }
  );

  const activityToInsert: ITrainingEntry = {
    user_id: userId,
    points: calculatePoints(response),
    duration: response.elapsed_time,
    calories: response.calories ?? undefined,
    distance: response.distance ?? undefined,
    type: response.type,
    created_at: response.start_date_local,
    strava_id: response.id,
    polyline: response.map.summary_polyline ?? undefined,
    elevation_change: response.elev_high - response.elev_low,
    average_speed: response.average_speed ?? 0,
  };

  const addTrainingsResponse = await addTrainings([activityToInsert]);

  if (addTrainingsResponse.points <= 0) {
    throw new Error("Points not awarded");
  }
};

export const handleStravaWebhookEvent = async ({
  aspect_type,
  event_time,
  object_id,
  object_type,
  owner_id,
  subscription_id,
  updates,
}: IStravaWebhookEvent) => {
  if (!subscription_id || !owner_id) {
    throw new Error("Invalid event credentials");
  }
  if (object_type !== STRAVA_EVENT_OBJECT_TYPE.ACTIVITY) {
    throw new Error("Unsupported event object type");
  }
  const stravaUserInfo = await getStravaUserInfoByAthleteId(owner_id);
  if (!stravaUserInfo.rowCount || stravaUserInfo.rowCount == 0) {
    throw new Error("No user info found for strava integration");
  }
  const data = stravaUserInfo.rows[0];
  if ("type" in updates && aspect_type === STRAVA_EVENT_TYPE.UPDATE) {
    return await updateStravaTraining(updates["type"], object_id);
  }

  let accessToken = data.access_token;
  const tokenExpiresAt = new Date(data.token_expires_at);

  if (tokenExpiresAt < new Date(Date.now())) {
    const refreshToken = data.refresh_token;
    accessToken = await refreshStravaToken(refreshToken, data.user_id);
  }

  await handleStravaActivityInfo({
    accessToken,
    activityId: object_id,
    userId: data.user_id,
  });
};

export const handleStravaWebhookVerification = ({
  mode,
  token,
  challenge,
}: IStravaWebhookVerificationRequest) => {
  const VERIFY_TOKEN = process.env.STRAVA_WEBHOOK_VERIFY_TOKEN ?? "";
  if (mode === STRAVA_WEBHOOK_MODE.SUBSCRIBE && token === VERIFY_TOKEN) {
    return challenge;
  } else {
    throw new Error("Verification failed");
  }
};
