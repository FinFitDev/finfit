import { refreshStravaToken } from "../../services/stravaService";
import { FetchHandlerOptions, HTTP_METHOD } from "../types/general";

export const fetchHandler = async (
  url: string,
  options: FetchHandlerOptions = {}
): Promise<any> => {
  try {
    const {
      method = HTTP_METHOD.GET,
      headers = {},
      body,
      isXML = false,
    } = options;

    const defaultHeaders = isXML
      ? { "Content-Type": "application/xml" }
      : { "Content-Type": "application/json" };

    const response = await fetch(url, {
      method,
      headers: {
        ...defaultHeaders,
        ...headers,
      },
      body: body ? (isXML ? body : JSON.stringify(body)) : undefined,
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`HTTP error ${response.status}: ${errorText}`);
    }

    const contentType = response.headers.get("content-type");
    if (contentType?.includes("application/json")) {
      return await response.json();
    } else {
      return await response.text();
    }
  } catch (error: any) {
    console.error("Fetch failed:", error.message);
    throw error;
  }
};
export const stravaFetchHandler = async (
  url: string,
  options: FetchHandlerOptions = {},
  refreshToken: string,
  userId: string
): Promise<any> => {
  const {
    method = HTTP_METHOD.GET,
    headers = {},
    body,
    isXML = false,
  } = options;

  const defaultHeaders = {
    "Content-Type": isXML ? "application/xml" : "application/json",
  };

  const prepareBody = body ? (isXML ? body : JSON.stringify(body)) : undefined;

  const doRequest = async (extraHeaders = {}) => {
    const response = await fetch(url, {
      method,
      headers: {
        ...defaultHeaders,
        ...headers,
        ...extraHeaders,
      },
      body: prepareBody,
    });

    if (!response.ok) {
      const error = await parseError(response);
      throw new HttpError(response.status, error);
    }

    const res = await parseResponse(response);
    return res;
  };

  try {
    return await doRequest();
  } catch (err: any) {
    if (err instanceof HttpError && err.status === 401) {
      const accessToken = await refreshStravaToken(refreshToken, userId);
      return await doRequest({
        Authorization: `Bearer ${accessToken.accessToken}`,
      });
    }

    throw err;
  }
};

class HttpError extends Error {
  status: number;
  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

async function parseResponse(response: Response) {
  const contentType = response.headers.get("content-type");
  return contentType?.includes("application/json")
    ? response.json()
    : response.text();
}

async function parseError(response: Response): Promise<string> {
  try {
    const text = await response.text();
    try {
      const json = JSON.parse(text);
      return json.error ?? JSON.stringify(json);
    } catch {
      return text;
    }
  } catch {
    return "Unknown error";
  }
}
