import { Request, Response } from "express";
import {
  addTransactionsToDb,
  getTransactions,
} from "../../../services/api/transactionsService";
import { RequestWithPayload } from "../../../shared/types";

export const addTransactionsHandler = async (req: Request, res: Response) => {
  try {
    const transactions = req.body.transactions;
    const response = await addTransactionsToDb(transactions);
    res.status(200).json({ message: "Transactions added", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when adding transactions",
      error: error.message,
    });
  }
};

export const getTransactionsHandler = async (
  req: RequestWithPayload<undefined, { user_id: string }>,
  res: Response
) => {
  try {
    const userId = req.params.user_id as string;
    const limit = req.query.limit as string;
    const offset = req.query.offset as string;
    const response = await getTransactions(
      userId,
      limit ? +limit : undefined,
      offset ? +offset : undefined
    );
    res.status(200).json({ message: "Transactions found", content: response });
  } catch (error: any) {
    res.status(error.statusCode ?? 404).json({
      message: "Something went wrong when fetching transactions",
      error: error.message,
    });
  }
};
