import { ITransactionInsert } from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchTransactions = async (
  userId: string,
  limit: number,
  offset: number
) => {
  const response = await pool.query(
    `
        SELECT
        t.uuid, t.amount_finpoints, t.created_at,
        (to_jsonb(p) || jsonb_build_object('product_owner', to_jsonb(po))) AS product,

        CASE
            WHEN t.second_user_id IS NULL THEN NULL
            WHEN t.user_id = $1 THEN 
                json_build_object(
                'uuid', su.uuid,
                'username', su.username,
                'email', su.email,
                'image', su.image
                )
            ELSE
                json_build_object(
                'uuid', u.uuid,
                'username', u.username,
                'email', u.email,
                'image', u.image
                )
        END AS second_user,

        CASE
            WHEN t.second_user_id IS NULL AND t.product_id IS NOT NULL THEN 'PURCHASE'
            WHEN t.user_id = $1 THEN 'SEND'
            ELSE 'RECEIVE'
        END AS type

        FROM transactions t

        LEFT JOIN products p ON t.product_id = p.uuid
        LEFT JOIN product_owners po ON p.owner_id = po.uuid

        LEFT JOIN users u ON t.user_id = u.uuid
        LEFT JOIN users su ON t.second_user_id = su.uuid

        WHERE 
        t.user_id = $1 OR t.second_user_id = $1

        ORDER BY t.created_at DESC
        LIMIT $2 OFFSET $3
      `,
    [userId, limit, offset]
  );

  return response;
};

// fetch transactions 7 days back - first fetch
export const fetchRecentUserTransactions = async (userId: string) => {
  const response = await pool.query(
    `
        SELECT
        t.uuid, t.amount_finpoints, t.created_at,
        (to_jsonb(p) || jsonb_build_object('product_owner', to_jsonb(po))) AS product,

        CASE
            WHEN t.second_user_id IS NULL THEN NULL
            WHEN t.user_id = $1 THEN 
                json_build_object(
                'uuid', su.uuid,
                'username', su.username,
                'email', su.email,
                'image', su.image
                )
            ELSE
                json_build_object(
                'uuid', u.uuid,
                'username', u.username,
                'email', u.email,
                'image', u.image
                )
        END AS second_user,

        CASE
            WHEN t.second_user_id IS NULL AND t.product_id IS NOT NULL THEN 'PURCHASE'
            WHEN t.user_id = $1 THEN 'SEND'
            ELSE 'RECEIVE'
        END AS type

        FROM transactions t

        LEFT JOIN products p ON t.product_id = p.uuid
        LEFT JOIN product_owners po ON p.owner_id = po.uuid

        LEFT JOIN users u ON t.user_id = u.uuid
        LEFT JOIN users su ON t.second_user_id = su.uuid

        WHERE 
        (t.user_id = $1 OR t.second_user_id = $1) AND t.created_at >= NOW() - INTERVAL '7 days'

        ORDER BY t.created_at DESC

      `,
    [userId]
  );

  return response;
};

export const insertTransactions = async (
  transactions: ITransactionInsert[]
) => {
  // Build the VALUES clause dynamically for bulk insert
  const values: any[] = [];
  let offset = 0;

  const placeholders = transactions
    .flatMap((transaction) => {
      // resolve second party ids
      const secondPartyIds = [
        ...(transaction.second_user_ids ?? []).map((id) => ({
          user_id: id,
          product_id: null,
        })),
        ...(transaction.product_ids ?? []).map((id) => ({
          user_id: null,
          product_id: id,
        })),
      ];

      console.log(secondPartyIds);

      return secondPartyIds.map(({ user_id, product_id }) => {
        values.push(
          transaction.amount_finpoints,
          transaction.user_id,
          user_id,
          product_id
        );

        const base = offset;
        offset += 5;

        return `($${base + 1}, $${base + 2}, $${base + 3}, $${base + 4})`;
      });
    })
    .join(", ");

  const response = await pool.query(
    `INSERT INTO transactions (amount_finpoints, user_id, second_user_id, product_id)
      VALUES ${placeholders}`,
    values
  );

  return response;
};
