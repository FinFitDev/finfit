import { pool } from "../shared/utils/db";

export const fetchProductsByRegex = async (
  regex: string,
  limit: number,
  offset: number
) => {
  const formattedRegex = `%${regex.toLowerCase()}%`;

  const response = await pool.query(
    "SELECT * FROM products p WHERE LOWER(p.name) LIKE $1 OR LOWER(p.owner) LIKE $1 ORDER BY p.total_transactions DESC LIMIT $2 OFFSET $3",
    [formattedRegex, limit, offset]
  );
  return response;
};

export const fetchAffordableProducts = async (
  points: number,
  limit: number,
  offset: number
) => {
  const response = await pool.query(
    `
        SELECT p.*,to_json(po) AS product_owner
        FROM products p
        LEFT JOIN product_owners po ON p.owner_id = po.uuid
        WHERE p.finpoints_price <= $1
        ORDER BY p.total_transactions DESC
        LIMIT $2
        OFFSET $3
    `,
    [points, limit, offset]
  );
  return response;
};

export const fetchNearlyAfforableProducts = async (points: number) => {
  const response = await pool.query(
    `
        SELECT p.*, to_json(po) AS product_owner
        FROM products p
        LEFT JOIN product_owners po ON p.owner_id = po.uuid
        WHERE p.finpoints_price > $1
        ORDER BY (p.finpoints_price - $1) ASC, p.total_transactions DESC
        LIMIT 10
      `,
    [points]
  );
  return response;
};

export const fetchMaxPriceRanges = async () => {
  const response = await pool.query(
    `
      SELECT 
        MAX(original_price) AS max_price,
        MAX(finpoints_price) AS max_finpoints_price
      FROM products;
      `
  );
  return response;
};
