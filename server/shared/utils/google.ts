import { OAuth2Client } from "google-auth-library";
import { GOOGLE_WEB_CLIENT_ID } from "../constants";

let googleClient: OAuth2Client | null = null;
export const getGoogleClient = () => {
  if (googleClient) {
    return googleClient;
  }

  googleClient = new OAuth2Client(GOOGLE_WEB_CLIENT_ID);
  return googleClient;
};

export const getDataFromIdToken = async (id_token: string) => {
  const googleClient = getGoogleClient();
  const ticket = await googleClient.verifyIdToken({
    idToken: id_token,
    audience: GOOGLE_WEB_CLIENT_ID, // Web Client ID from Google Cloud Console
  });
  const payload = ticket.getPayload();
  return payload;
};
