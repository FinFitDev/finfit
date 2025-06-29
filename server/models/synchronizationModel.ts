import { IAllShops, SHOP_PROVIDER } from "../shared/types/synchronization";
import { pool } from "../shared/utils/db";

export const fetchProductOwnersWithAvailableAPI = async () => {
  const response = await pool.query(
    `SELECT uuid, api_key, api_url, shop_type FROM product_owners
    WHERE api_url IS NOT NULL 
    AND api_key IS NOT NULL
    AND shop_type IS NOT NULL
      `
  );
  return response.rows;
};

export async function updateStockFromAllShops(allShops: IAllShops) {
  const productIds: string[] = [];
  const ownerIds: string[] = [];
  const stockValues: number[] = [];
  const variantJsons: (string | null)[] = [];

  for (const shopType in allShops) {
    const shopsByUUID = allShops[shopType as SHOP_PROVIDER];

    for (const shopUuid in shopsByUUID) {
      const products = shopsByUUID[shopUuid];

      for (const product of products) {
        productIds.push(product.productId);
        ownerIds.push(shopUuid);
        stockValues.push(product.quantity);

        if (product.variants?.length) {
          const variantMap: Record<string, number> = {};
          for (const variant of product.variants) {
            variantMap[variant.variantId] = variant.quantity;
          }
          variantJsons.push(JSON.stringify(variantMap));
        } else {
          variantJsons.push(null);
        }
      }
    }
  }

  if (!productIds.length) return;

  await pool.query(
    `
        UPDATE products AS p SET
          in_stock = data.in_stock,
          variants = CASE
            WHEN data.variant_map IS NULL THEN p.variants::jsonb
            ELSE (
              SELECT jsonb_agg(
                jsonb_set(
                  v,
                  '{in_stock}',
                  to_jsonb(
                    COALESCE((data.variant_map ->> (v->>'id'))::int, (v->>'in_stock')::int)
                  )
                )
              )
              FROM jsonb_array_elements(p.variants::jsonb) AS v
            )
          END
        FROM (
          SELECT 
            unnest($1::varchar[]) AS product_id,
            unnest($2::uuid[]) AS owner_id,
            unnest($3::int[]) AS in_stock,
            unnest($4::jsonb[]) AS variant_map
        ) AS data
        WHERE p.reference_id = data.product_id AND p.owner_id = data.owner_id
      `,
    [productIds, ownerIds, stockValues, variantJsons]
  );
}
