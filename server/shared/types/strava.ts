export enum STRAVA_WEBHOOK_MODE {
  SUBSCRIBE = "subscribe",
}

export enum STRAVA_EVENT_TYPE {
  CREATE = "create",
  UPDATE = "update",
}

export enum STRAVA_EVENT_OBJECT_TYPE {
  ACTIVITY = "activity",
}
export interface IStravaWebhookVerificationRequest {
  mode: STRAVA_WEBHOOK_MODE;
  token: string;
  challenge: string;
}

export interface IStravaWebhookEvent {
  aspect_type: STRAVA_EVENT_TYPE;
  event_time: number;
  object_id: number;
  object_type: STRAVA_EVENT_OBJECT_TYPE;
  owner_id: number;
  subscription_id: number;
  updates: Record<string, any>;
}

// Main Strava OAuth token response
export interface IStravaAuthResponse {
  expires_at: number;
  expires_in: number;
  refresh_token: string;
  access_token: string;
  athlete: IStravaAthlete;
}

// Athlete profile from Strava
export interface IStravaAthlete {
  id: number;
  username: string | null;
  resource_state: number;
  firstname: string;
  lastname: string;
  bio: string | null;
  city: string;
  state: string;
  country: string;
  sex: "M" | "F" | null;
  premium: boolean;
  summit: boolean;
  created_at: string;
  updated_at: string;
  badge_type_id: number;
  weight: number;
  profile_medium: string | null;
  profile: string | null;
  friend: any | null;
  follower: any | null;
}

export interface IUserStravaInsertPayload {
  userId: string;
  athleteId: number;
  accessToken: string;
  refreshToken: string;
  tokenExpiresIn: number;
}

export interface IUserStravaRefreshPayload
  extends Omit<IUserStravaInsertPayload, "athleteId"> {}

export interface IStravaActivityInfoRequest {
  accessToken: string;
  activityId: number;
  userId: string;
}

export interface IStravaActivityInfoResponse {
  id: number;
  name: string;
  distance: number | null;
  moving_time: number;
  elapsed_time: number;
  total_elevation_gain: number;
  type: string;
  sport_type: string;
  start_date: string;
  start_date_local: string;
  timezone: string;
  map: {
    summary_polyline: string | null;
  };
  average_speed: number;
  max_speed: number;
  calories: number | null;
  has_heartrate: boolean;
  elev_high: number;
  elev_low: number;
  description: string | null;
}
