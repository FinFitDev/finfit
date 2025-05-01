import { pool } from "../shared/utils/db";

export const fetchProductOwnersByRegex = async (
  regex: string,
  limit: number,
  offset: number
) => {
  const formattedRegex = `%${regex.toLowerCase()}%`;

  const response = await pool.query(
    `SELECT * FROM product_owners po
    WHERE LOWER(po.name) LIKE $1
     ORDER BY po.total_transactions DESC
     LIMIT $2
     OFFSET $3`,
    [formattedRegex, limit, offset]
  );
  return response;
};
