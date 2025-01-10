import { OAuth2Client } from "google-auth-library";
import { ANDROID_WEB_CLIENT_ID, IOS_WEB_CLIENT_ID } from "../constants";

let googleClient: OAuth2Client | null = null;
export const getGoogleClient = (platform: string) => {
  if (googleClient) {
    return googleClient;
  }

  googleClient = new OAuth2Client(platform === 'ios' ? IOS_WEB_CLIENT_ID : ANDROID_WEB_CLIENT_ID);
  return googleClient;
};

export const getDataFromIdToken = async (id_token: string, platform: string) => {
  const googleClient = getGoogleClient(platform);
  const ticket = await googleClient.verifyIdToken({
    idToken: id_token,
    audience: platform === 'ios' ? IOS_WEB_CLIENT_ID : ANDROID_WEB_CLIENT_ID
  });
  const payload = ticket.getPayload();
  return payload;
};
