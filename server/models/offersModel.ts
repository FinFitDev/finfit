import { PoolClient } from "pg";
import { pool } from "../shared/utils/db";

export const fetchFeaturedOffers = async (limit: number, offset: number) => {
  const response = await pool.query(
    `
        SELECT o.*, to_json(p) AS partner
        FROM offers o
        LEFT JOIN partners p ON o.partner_id = p.uuid
        WHERE o.featured = TRUE AND o.valid_until >= NOW()
        ORDER BY o.total_redeemed DESC
        LIMIT $1
        OFFSET $2
    `,
    [limit, offset]
  );
  return response;
};

export const fetchPaginatedOffers = async (
  search: string,
  limit: number,
  offset: number
) => {
  const formattedRegex = `%${search.toLowerCase()}%`;

  const response = await pool.query(
    `
        SELECT o.*, to_json(p) AS partner
        FROM offers o
        LEFT JOIN partners p ON o.partner_id = p.uuid
        WHERE LOWER(o.description) LIKE $1 OR LOWER(p.name) LIKE $1 AND o.valid_until >= NOW()
        ORDER BY o.total_redeemed DESC
        LIMIT $2
        OFFSET $3
    `,
    [formattedRegex, limit, offset]
  );
  return response;
};

export const fetchAffordableOffers = async (
  points: number,
  limit: number,
  offset: number
) => {
  const response = await pool.query(
    `
        SELECT o.*, to_json(p) AS partner
        FROM offers o
        LEFT JOIN partners p ON o.partner_id = p.uuid
        WHERE o.points <= $1
        ORDER BY o.total_redeemed DESC
        LIMIT $2
        OFFSET $3
    `,
    [points, limit, offset]
  );
  return response;
};

export const fetchOfferCodeDetails = async (
  offerId: number,
  client?: PoolClient
) => {
  const executor = client ?? pool;
  const response = await executor.query(
    `SELECT o.points, o.code_expiration_period, o.api_payload, p.uuid, p.api_key, p.api_url, p.shop_type, p.consumer_key, p.consumer_secret FROM offers o
      JOIN partners p ON p.uuid = o.partner_id
      WHERE o.id = $1`,
    [offerId]
  );

  return response;
};

export const updateOfferTotalRedeemed = async (
  offerId: number,
  client?: PoolClient
) => {
  const executor = client ?? pool;
  const response = await executor.query(
    `UPDATE offers
    SET total_redeemed = total_redeemed + 1
    WHERE id = $1`,
    [offerId]
  );

  return response;
};
