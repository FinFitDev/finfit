import { PoolClient } from "pg";
import { pool } from "../shared/utils/db";

export const fetchUserClaims = async (userId: string) => {
  const response = await pool.query(
    `
    SELECT 
      dc.*, 
      (to_jsonb(o) || jsonb_build_object('partner', to_jsonb(p))) AS offer
    FROM discount_codes dc
    JOIN offers o ON o.id = dc.offer_id
    JOIN partners p ON p.uuid = o.partner_id
    WHERE dc.user_id = $1
      AND dc.status = 'ACTIVE'
      AND dc.valid_until > NOW()
    ORDER BY dc.created_at DESC
    `,
    [userId]
  );

  return response;
};
export const insertDiscountCode = async (
  userId: string,
  offerId: number,
  validUntil: Date,
  client?: PoolClient
) => {
  const executor = client ?? pool;
  const response = await executor.query(
    `INSERT INTO discount_codes (code, user_id, offer_id, valid_until)
     VALUES (encode(gen_random_bytes(8), 'hex'), $1, $2, $3)
     RETURNING code`,
    [userId, offerId, validUntil]
  );

  return response;
};

export const setDicountCodeUsed = async (code: string) => {
  const response = await pool.query(
    `UPDATE discount_codes
    SET status = 'USED', used_timestamp = NOW()
    WHERE code = $1`,
    [code]
  );

  return response;
};

export const getDiscountCodeForPartner = async (
  code: string,
  partnerId: string
) => {
  const response = await pool.query(
    `SELECT dc.code, o.api_payload FROM discount_codes dc
    JOIN offers o ON o.id = dc.offer_id
    WHERE dc.code = $1 AND o.partner_id = $2 AND dc.status = 'ACTIVE' AND dc.valid_until > NOW()`,
    [code, partnerId]
  );

  return response;
};
