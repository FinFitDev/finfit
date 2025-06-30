import { PoolClient } from "pg";
import { pool } from "../shared/utils/db";
import { ITransactionInsert } from "../shared/types/shop";

export const fetchTransactions = async (
  userId: string,
  limit?: number,
  offset?: number,
  daysBack?: number
) => {
  let whereClause = `
   (
      t.user_id = $1 OR 
      $1 = ANY (
        SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
      )
    )
  `;

  if (daysBack) {
    whereClause += ` AND t.created_at >= NOW() - INTERVAL '${daysBack} days'`;
  }

  let limitOffsetClause = "";
  const params: any[] = [userId];

  if (typeof limit === "number" && typeof offset === "number") {
    params.push(limit, offset);
    limitOffsetClause = `LIMIT $${params.length - 1} OFFSET $${params.length}`;
  }

  const query = `
      SELECT
      t.uuid,
      t.amount_finpoints,
      t.created_at,

      -- users: either single user (sender) if RECEIVE, else all second users
      CASE
        WHEN $1 = ANY (
          SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
        )
        THEN
          -- single user json array for the sender
          jsonb_build_array(
            jsonb_build_object(
              'uuid', t.user_id,
              'username', u1.username,
              'email', u1.email,
              'image', u1.image
            )
          )
        ELSE
          -- aggregated json array of second users
          COALESCE(
            jsonb_agg(DISTINCT jsonb_build_object(
              'uuid', u.uuid,
              'username', u.username,
              'email', u.email,
              'image', u.image
            )) FILTER (WHERE u.uuid IS NOT NULL),
            '[]'
          )
      END AS second_users,

      COALESCE(
        jsonb_agg(DISTINCT
          jsonb_build_object(
            'variant_id', product_json.elem->>'variant_id',
            'quantity', (product_json.elem->>'quantity')::int,
            'product', to_jsonb(p) || jsonb_build_object('product_owner', to_jsonb(po))
          )
        ) FILTER (WHERE p.uuid IS NOT NULL),
        '[]'
      ) AS products,

      -- type logic
      CASE
        WHEN (t.second_user_ids IS NULL OR jsonb_array_length(t.second_user_ids) = 0)
            AND (t.product_ids IS NOT NULL AND jsonb_array_length(t.product_ids) > 0)
        THEN 'PURCHASE'
        WHEN $1 = ANY (
          SELECT jsonb_array_elements_text(t.second_user_ids)::uuid
        ) THEN 'RECEIVE'
        ELSE 'SEND'
      END AS type

    FROM transactions t

    -- join the single sender user to get its info
    LEFT JOIN users u1 ON u1.uuid = t.user_id

    -- unnest second_user_ids to join users for aggregation
    LEFT JOIN LATERAL jsonb_array_elements_text(t.second_user_ids) AS second_user_id(id) ON TRUE
    LEFT JOIN users u ON u.uuid = CAST(second_user_id.id AS uuid)

    -- unnest product_ids to join products and product owners
    LEFT JOIN LATERAL jsonb_array_elements(t.product_ids) AS product_json(elem) ON TRUE
    LEFT JOIN products p ON p.uuid = (product_json.elem->>'id')::uuid
    LEFT JOIN product_owners po ON p.owner_id = po.uuid

    WHERE ${whereClause}
    GROUP BY t.uuid, t.amount_finpoints, t.created_at, t.second_user_ids, t.product_ids, u1.uuid, u1.username, u1.email, u1.image
    ORDER BY t.created_at DESC
    ${limitOffsetClause}
  `;

  const response = await pool.query(query, params);
  return response;
};

export const insertTransactions = async (
  transactions: ITransactionInsert[],
  poolClient?: PoolClient
) => {
  const values: any[] = [];
  let offset = 0;

  const placeholders = transactions
    .map((transaction) => {
      values.push(
        transaction.amount_finpoints,
        transaction.user_id,
        JSON.stringify(transaction.second_user_ids ?? []),
        JSON.stringify(transaction.product_data ?? [])
      );

      const base = offset;
      offset += 4;

      return `($${base + 1}, $${base + 2}, $${base + 3}, $${base + 4})`;
    })
    .join(", ");

  console.log(placeholders);

  const sql = `
    INSERT INTO transactions
      (amount_finpoints, user_id, second_user_ids, product_ids)
    VALUES
      ${placeholders}
  `;

  const response = await (poolClient ?? pool).query(sql, values);

  return response;
};
