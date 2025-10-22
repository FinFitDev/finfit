export enum HTTP_METHOD {
  GET = "GET",
  POST = "POST",
  PUT = "PUT",
  DELETE = "DELETE",
  PATCH = "PATCH",
  HEAD = "HEAD",
  OPTIONS = "OPTIONS",
}

export type FetchHandlerOptions = {
  method?: HTTP_METHOD;
  headers?: Record<string, string>;
  body?: any;
  isXML?: boolean;
};
