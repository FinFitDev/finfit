import { QueryResult } from "pg";
import { ErrorWithCode } from "../../../exceptions/errorWithCode";
import {
  deleteHourlySteps,
  extractExpiredHourlySteps,
  fetchRecentUserTrainings,
  fetchUserTrainings,
  insertDailySteps,
  insertHourlySteps,
  insertNewTrainingsPointsUpdateTransaction,
  insertTraining,
} from "../../../models/activityModel";
import { ONE_DAY_MILLISECONDS } from "../../../shared/constants";
import {
  IDailyStepEntry,
  IHourlyStepEntry,
  ITrainingEntry,
  ITrainingEntryResponse,
} from "../../../shared/types";
import { aggregateDailyDataObject } from "../../../shared/utils";

export const getUserTrainings = async (
  user_id: string,
  limit?: number,
  offset?: number
) => {
  // Fetch recent trainings if no offset or offset is 0
  let foundTrainings =
    !offset || offset === 0
      ? await fetchRecentUserTrainings(user_id)
      : undefined;

  // If offset exists or we need more data based on row count
  if (offset || (foundTrainings?.rowCount ?? 0) < (limit ?? 0)) {
    const local = await fetchUserTrainings(
      user_id,
      (limit ?? 0) - (foundTrainings?.rowCount ?? 0),
      (offset ?? 0) + (foundTrainings?.rowCount ?? 0)
    );
    foundTrainings = foundTrainings
      ? {
          ...foundTrainings,
          rows: [...foundTrainings.rows, ...local.rows],
          rowCount: (foundTrainings.rowCount ?? 0) + (local.rowCount ?? 0),
        }
      : local;
  }

  return foundTrainings?.rows as ITrainingEntryResponse[];
};

export const addTrainings = async (trainings: string[]) => {
  if (!trainings.length) {
    return "0";
  }
  const parsedTrainings: ITrainingEntry[] = trainings.map((training) =>
    JSON.parse(training)
  );
  const userId = parsedTrainings[0].user_id;
  const response = await insertNewTrainingsPointsUpdateTransaction(
    parsedTrainings,
    userId
  );
  return response;
};

// --------------------------------------- DEPRECATED --------------------------------------- //

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
  user_id: string,
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
