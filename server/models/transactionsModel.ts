import { PoolClient } from "pg";
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
      t.uuid,

      CASE
        WHEN $1 = ANY(ARRAY(
          SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
        ))
        THEN t.amount_points / GREATEST(
          jsonb_array_length(t.second_user_ids), 1
        )
        ELSE t.amount_points
      END AS amount_points,

      t.created_at,
      (to_jsonb(o) || jsonb_build_object('partner', to_jsonb(p))) AS offer,

      CASE
        WHEN t.second_user_ids IS NULL THEN NULL
        WHEN t.user_id = $1 THEN 
          (
            SELECT json_agg(json_build_object(
              'uuid', u.uuid,
              'username', u.username,
              'email', u.email,
              'image', u.image
            ))
            FROM users u
            WHERE u.uuid = ANY(ARRAY(
              SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
            ))
          )
        ELSE
          (
            SELECT json_agg(json_build_object(
              'uuid', u.uuid,
              'username', u.username,
              'email', u.email,
              'image', u.image
            ))
            FROM users u
            WHERE u.uuid = t.user_id
          )
      END AS second_users,

      CASE
        WHEN t.second_user_ids IS NULL AND t.offer_id IS NOT NULL THEN 'REDEEM'
        WHEN t.user_id = $1 THEN 'SEND'
        ELSE 'RECEIVE'
      END AS type

    FROM transactions t
    LEFT JOIN offers o ON t.offer_id = o.id
    LEFT JOIN partners p ON o.partner_id = p.uuid

    WHERE $1 = t.user_id OR $1 = ANY(ARRAY(
      SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
    ))

    ORDER BY t.created_at DESC
    LIMIT $2 OFFSET $3
    `,
    [userId, limit, offset]
  );

  return response;
};

export const fetchRecentUserTransactions = async (userId: string) => {
  const response = await pool.query(
    `
    SELECT
      t.uuid,

      CASE
        WHEN $1 = ANY(ARRAY(
          SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
        ))
        THEN t.amount_points / GREATEST(jsonb_array_length(t.second_user_ids), 1)
        ELSE t.amount_points
      END AS amount_points,

      t.created_at,
      (to_jsonb(o) || jsonb_build_object('partner', to_jsonb(p))) AS offer,

      CASE
        WHEN t.second_user_ids IS NULL THEN NULL
        WHEN t.user_id = $1 THEN 
          (
            SELECT json_agg(json_build_object(
              'uuid', u.uuid,
              'username', u.username,
              'email', u.email,
              'image', u.image
            ))
            FROM users u
            WHERE u.uuid = ANY(ARRAY(
              SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
            ))
          )
        ELSE
          (
            SELECT json_agg(json_build_object(
              'uuid', u.uuid,
              'username', u.username,
              'email', u.email,
              'image', u.image
            ))
            FROM users u
            WHERE u.uuid = t.user_id
          )
      END AS second_users,

      CASE
        WHEN t.second_user_ids IS NULL AND t.offer_id IS NOT NULL THEN 'REDEEM'
        WHEN t.user_id = $1 THEN 'SEND'
        ELSE 'RECEIVE'
      END AS type

    FROM transactions t
    LEFT JOIN offers o ON t.offer_id = o.id
    LEFT JOIN partners p ON o.partner_id = p.uuid

    WHERE ($1 = t.user_id OR $1 = ANY(ARRAY(
      SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
    ))) 
      AND t.created_at >= NOW() - INTERVAL '7 days'

    ORDER BY t.created_at DESC
    `,
    [userId]
  );

  return response;
};
export const insertTransactions = async (
  transactions: ITransactionInsert[],
  poolClient?: PoolClient
) => {
  if (!transactions.length) return;

  const values: any[] = [];
  const placeholders: string[] = [];

  transactions.forEach((transaction, index) => {
    const base = index * 4;

    // second_user_ids as JSON array
    const secondUserIdsJson = transaction.second_user_ids
      ? JSON.stringify(transaction.second_user_ids)
      : null;

    values.push(
      transaction.amount_points * (transaction.second_user_ids?.length ?? 1),
      transaction.user_id,
      secondUserIdsJson,
      transaction.offer_id ?? null
    );

    placeholders.push(
      `($${base + 1}, $${base + 2}, $${base + 3}::jsonb, $${base + 4})`
    );
  });

  const query = `
    INSERT INTO transactions (amount_points, user_id, second_user_ids, offer_id)
    VALUES ${placeholders.join(", ")}
  `;

  const response = await (poolClient ?? pool).query(query, values);

  return response;
};
