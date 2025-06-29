import { pool } from "../shared/utils/db";

export const fetchExternalDeliveryOptionId = async (
  ownerId: string,
  methodId: string
) => {
  const response = await pool.query(
    `SELECT external_id FROM join_owners_deliveries
      WHERE product_owner_id = $1
     AND delivery_method_id = $2`,
    [ownerId, methodId]
  );

  return response.rows?.[0]?.external_id;
};
