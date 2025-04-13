import {
  fetchTransactions,
  insertTransactions,
} from "../../../models/transactionsModel";
import { ITransactionInsert } from "../../../shared/types";

export const addTransactionsToDb = async (
  transactions: ITransactionInsert[]
) => {
  if (!transactions || transactions.length === 0) {
    throw new Error("No transactions to insert");
  }
  const response = await insertTransactions(transactions);

  return response.rowCount;
};

export const getTransactions = async (
  userId: string,
  limit?: string,
  offset?: string
) => {
  if (!userId) {
    throw new Error("No userId provided");
  }

  const response = await fetchTransactions(
    userId,
    +(limit ?? 20),
    +(offset ?? 0)
  );

  return response.rows;
};
