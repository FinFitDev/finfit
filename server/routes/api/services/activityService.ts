import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import { fetchRecentUserTrainings, insertTraining } from "../../../models/activityModel";
import { ITrainingEntry, ITrainingEntryResponse } from "../../../shared/types";

export const getUserRecentTrainings = async (user_id: number, limit?:number, offset?:number) => {
  const foundTrainings = await fetchRecentUserTrainings(user_id, limit, offset);
  return foundTrainings.rows as ITrainingEntryResponse[];
};

export const addTrainings = async (
trainings: string[]
) => {
  const promises = trainings.map((training) => {
   return insertTraining(JSON.parse(JSON.stringify(training)))
})
  const responses = await Promise.all(promises)
  return responses;
};
