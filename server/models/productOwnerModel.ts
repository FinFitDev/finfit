import { pool } from "../shared/utils/db";

export const fetchProductOwnersByRegex = async (
  regex: string,
  limit: number,
  offset: number
) => {
  const formattedRegex = `%${regex.toLowerCase()}%`;

  const response = await pool.query(
    `SELECT * FROM product_owners_with_delivery_methods
      WHERE LOWER(name) LIKE $1
      ORDER BY total_transactions DESC
      LIMIT $2 OFFSET $3`,
    [formattedRegex, limit, offset]
  );

  return response;
};

export const fetchProductOwnerAPIById = async (uuid: string) => {
  const response = await pool.query(
    `SELECT uuid, api_key, api_url, shop_type FROM product_owners
    WHERE api_url IS NOT NULL 
    AND api_key IS NOT NULL
    AND shop_type IS NOT NULL
    AND uuid = $1
      `,
    [uuid]
  );
  return response.rows;
};
