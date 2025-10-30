import { pool } from "../shared/utils/db";

export const fetchPartnersByRegex = async (
  regex: string,
  limit: number,
  offset: number
) => {
  const formattedRegex = `%${regex.toLowerCase()}%`;

  const response = await pool.query(
    `SELECT * FROM partners
      WHERE LOWER(name) LIKE $1
      LIMIT $2 OFFSET $3`,
    [formattedRegex, limit, offset]
  );

  return response;
};

export const fetchProductOwnerAPIById = async (uuid: string) => {
  const response = await pool.query(
    `SELECT uuid, api_key, api_url, shop_type FROM partners
    WHERE api_url IS NOT NULL 
    AND api_key IS NOT NULL
    AND shop_type IS NOT NULL
    AND uuid = $1
      `,
    [uuid]
  );
  return response.rows;
};

export const fetchPartnerByPasscode = async (token: string) => {
  const response = await pool.query(
    `SELECT uuid, name, image FROM partners
    WHERE api_key = $1 
      `,
    [token]
  );
  return response;
};

export const fetchPartnerMinimalMetadataByUuid = async (uuid: string) => {
  const response = await pool.query(
    `SELECT uuid, name, image FROM partners
    WHERE uuid = $1 
      `,
    [uuid]
  );
  return response;
};
