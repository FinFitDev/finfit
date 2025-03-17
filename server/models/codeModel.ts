import { IResetPasswordCode } from "../shared/types";
import { pool } from "../shared/utils/db";

// Used to generate a correct code for the user
export const getCodeByCodeFromDb = async (code: IResetPasswordCode) => {
  const response = await pool.query(
    `SELECT * FROM reset_codes WHERE code = $1 AND expires_at > NOW()`,
    [code]
  );

  return !!((response.rowCount ?? 0) > 0);
};

export const getCodeByUserIdFromDb = async (userId: string) => {
  const response = await pool.query(
    `SELECT * FROM reset_codes WHERE user_id = $1 AND expires_at > NOW()`,
    [userId]
  );

  return response;
};

// ensures each user id has only one code at a time
export const insertCodeToDb = async (
  code: IResetPasswordCode,
  userId: string
) => {
  const response = await pool.query(
    `INSERT INTO reset_codes (code, user_id,  expires_at)
    VALUES ($1, $2, NOW() + INTERVAL '5 minutes')
    ON CONFLICT (user_id)
    DO UPDATE SET 
        code = $1,
        expires_at = NOW() + INTERVAL '5 minutes'`,
    [code, userId]
  );

  return response;
};
