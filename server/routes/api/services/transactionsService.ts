import {
  fetchRecentUserTransactions,
  fetchTransactions,
  insertTransactions,
} from "../../../models/transactionsModel";
import {
  ITransactionEntryResponse,
  ITransactionInsert,
} from "../../../shared/types/shop";

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
  limit?: number,
  offset?: number
) => {
  if (!userId) {
    throw new Error("No userId provided");
  }

  // Fetch recent trainings if no offset or offset is 0
  let foundTransactions =
    !offset || offset === 0
      ? await fetchRecentUserTransactions(userId)
      : undefined;

  // If offset exists or we need more data based on row count
  if (offset || (foundTransactions?.rowCount ?? 0) < (limit ?? 0)) {
    const local = await fetchTransactions(
      userId,
      (limit ?? 0) - (foundTransactions?.rowCount ?? 0),
      (offset ?? 0) + (foundTransactions?.rowCount ?? 0)
    );
    foundTransactions = foundTransactions
      ? {
          ...foundTransactions,
          rows: [...foundTransactions.rows, ...local.rows],
          rowCount: (foundTransactions.rowCount ?? 0) + (local.rowCount ?? 0),
        }
      : local;
  }

  return foundTransactions?.rows as ITransactionEntryResponse[];
};
