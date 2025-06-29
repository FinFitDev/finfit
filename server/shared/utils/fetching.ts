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
