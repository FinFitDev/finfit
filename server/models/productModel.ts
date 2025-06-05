import { IFiltersQuery, ORDER_TYPE } from "../shared/types";
import { pool } from "../shared/utils/db";

export const fetchProductsByFilters = async (query: IFiltersQuery) => {
  const conditions: string[] = [];
  const values: any[] = [];
  let paramIndex = 1;

  // Search by name (ILIKE %search%)
  if (query.search !== undefined) {
    conditions.push(`LOWER(p.name) ILIKE $${paramIndex}`);
    values.push(`%${query.search.toLowerCase()}%`);
    paramIndex++;
  }

  // Filter by category
  if (query.category !== undefined) {
    conditions.push(`LOWER(p.category) = LOWER($${paramIndex})`);
    values.push(query.category);
    paramIndex++;
  }

  // Min price
  if (query.min_price !== undefined) {
    conditions.push(`p.original_price >= $${paramIndex}`);
    values.push(query.min_price);
    paramIndex++;
  }

  // Max price
  if (query.max_price !== undefined) {
    conditions.push(`p.original_price <= $${paramIndex}`);
    values.push(query.max_price);
    paramIndex++;
  }

  // Min finpoints
  if (query.min_finpoints !== undefined) {
    conditions.push(`p.finpoints_price >= $${paramIndex}`);
    values.push(query.min_finpoints);
    paramIndex++;
  }

  // Max finpoints
  if (query.max_finpoints !== undefined) {
    conditions.push(`p.finpoints_price <= $${paramIndex}`);
    values.push(query.max_finpoints);
    paramIndex++;
  }

  // WHERE clause (optional)
  const whereClause =
    conditions.length > 0 ? `WHERE ${conditions.join(" AND ")}` : "";

  // Sort + order
  const validSortColumns = [
    "original_price",
    "discount",
    "finpoints_price",
    "created_at",
    "total_transactions",
    "name",
  ]; // Whitelist allowed columns
  const sortBy = validSortColumns.includes(query.sort_by ?? "")
    ? query.sort_by
    : "total_transactions";
  const order = query.order === ORDER_TYPE.ASCENDING ? "ASC" : "DESC";

  // Pagination defaults
  const limit = query.limit ?? 20;
  const offset = query.offset ?? 0;

  // Add limit/offset to values array
  values.push(limit);
  paramIndex++;
  values.push(offset);
  paramIndex++;

  const sql = `
    SELECT p.*, to_json(po) AS product_owner
    FROM products p
    LEFT JOIN product_owners po ON p.owner_id = po.uuid
    ${whereClause}
    ORDER BY p.${sortBy} ${order}
    LIMIT $${paramIndex - 2}
    OFFSET $${paramIndex - 1}
  `;

  const response = await pool.query(sql, values);

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
        WHERE p.finpoints_price > $1 AND (p.finpoints_price - $1) < 10000
        ORDER BY (p.finpoints_price - $1) ASC, p.total_transactions DESC
        LIMIT 5
      `,
    [points]
  );
  return response;
};

export const fetchProducts = async (limit: number, offset: number) => {
  const response = await pool.query(
    `
        SELECT p.*,to_json(po) AS product_owner
        FROM products p
        LEFT JOIN product_owners po ON p.owner_id = po.uuid
        ORDER BY p.total_transactions DESC
        LIMIT $2
        OFFSET $3
    `,
    [limit, offset]
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

export const fetchAllAvailableCategories = async () => {
  const response = await pool.query(
    `
      SELECT 
        DISTINCT(category)
      FROM products;
      `
  );
  return response;
};

export const fetchProductsForProductOwner = async (
  owner_id: string,
  limit: number,
  offset: number
) => {
  const response = await pool.query(
    `
        SELECT p.*,to_json(po) AS product_owner
        FROM products p
        LEFT JOIN product_owners po ON p.owner_id = po.uuid
        WHERE po.uuid = $1
        ORDER BY p.total_transactions DESC
        LIMIT $2
        OFFSET $3
    `,
    [owner_id, limit, offset]
  );
  return response;
};
