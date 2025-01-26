import { QueryResult } from "pg";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  deleteHourlySteps,
  extractExpiredHourlySteps,
  fetchRecentUserTrainings,
  insertDailySteps,
  insertHourlySteps,
  insertTraining,
} from "../../../models/activityModel";
import { ONE_DAY_MILLISECONDS } from "../../../shared/constants";
import {
  IDailyStepEntry,
  IHourlyStepEntry,
  ITrainingEntry,
  ITrainingEntryResponse,
} from "../../../shared/types";
import {
  aggregateDailyDataObject,
  getUtcMidnightDate,
} from "../../../shared/utils";

export const getUserRecentTrainings = async (
  user_id: number,
  limit?: number,
  offset?: number
) => {
  const foundTrainings = await fetchRecentUserTrainings(user_id, limit, offset);
  return foundTrainings.rows as ITrainingEntryResponse[];
};

export const addTrainings = async (trainings: string[]) => {
  const promises = trainings.map((training) => {
    return insertTraining(JSON.parse(training));
  });
  const responses = await Promise.all(promises);
  return responses;
};

export const addStepsData = async (hourlySteps: string[]) => {
  const hourlyStepsParsed = hourlySteps.map((data) => JSON.parse(data));
  const now = Date.now();
  // if the data from frontend is already older than the threshold date, we merge it directly into the daily_steps table
  const dataToMergeAggregate: IHourlyStepEntry[] = [];

  const promises = hourlyStepsParsed.map((hourlyData) => {
    const diff = new Date(hourlyData.timestamp).getTime() - now;
    // data is in the future (error)
    if (diff > 0) {
      return Promise.reject("Invalid timestamp");
    }

    if (Math.abs(diff) < 5 * ONE_DAY_MILLISECONDS) {
      return insertHourlySteps(hourlyData);
    } else {
      dataToMergeAggregate.push(hourlyData);
      return Promise.resolve({ [hourlyData.uuid]: true });
    }
  });

  const responses = await Promise.all(promises);

  await aggregateExpiredData(
    new Date(now - 5 * ONE_DAY_MILLISECONDS),
    hourlyStepsParsed[0].user_id,
    dataToMergeAggregate
  );

  return responses;
};

export const aggregateExpiredData = async (
  thresholdDate: Date,
  user_id: number,
  dataToMergeAggregate: IHourlyStepEntry[]
) => {
  const responseSelectExpired: QueryResult<IHourlyStepEntry> =
    await extractExpiredHourlySteps(thresholdDate, user_id);
  const deleteExpiredResponse = await deleteHourlySteps(
    responseSelectExpired?.rows?.map((item) => item.uuid) ?? []
  );

  // shouldnt happen
  if (deleteExpiredResponse.rowCount != responseSelectExpired.rowCount) {
    throw new Error(
      "Inconsistent length of found expired items and deleted expired items"
    );
  }

  const dailyData = aggregateDailyDataObject([
    ...responseSelectExpired?.rows,
    ...dataToMergeAggregate,
  ]);
  const promisesInsertDaily = Object.values(dailyData)?.map((item) => {
    return insertDailySteps(item);
  });
  await Promise.all(promisesInsertDaily);

  return "Successful data aggregation";
};
