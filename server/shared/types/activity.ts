export interface ITrainingEntry {
  points: number;
  duration: number;
  calories?: number;
  distance?: number;
  type: string;
  user_id: string;
  uuid: number;
  created_at?: string;
}

export interface ITrainingEntryResponse {
  id: number;
  created_at: string;
  points: number;
  duration: number;
  calories?: number;
  distance?: number;
  type: string;
}

export interface IHourlyStepEntry {
  uuid: string;
  timestamp: string;
  total: number;
  user_id: string;
}

export interface IDailyStepEntry {
  uuid: string;
  timestamp: string;
  total: number;
  user_id: string;
  mean: number;
}
