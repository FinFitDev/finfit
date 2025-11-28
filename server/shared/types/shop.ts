import { IOffer, IUser } from "../types";

export enum ORDER_TYPE {
  ASCENDING = "ASCENDING",
  DESCENDING = "DESCENDING",
}

export interface IClaim {
  code: string;
  created_at: string;
  valid_until: string;
  offer: IOffer;
}
