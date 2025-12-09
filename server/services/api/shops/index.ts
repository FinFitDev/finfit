import { SHOP_PROVIDER } from "../../../shared/types/integrations";
import { IIssueDiscountCodeShopPayload } from "../../../shared/types/integrations/general";

import { insertPrestashopDiscountCode } from "./prestahop";
import { insertShopifyDiscountCode } from "./shopify";
import { insertWoocommerceDiscountCode } from "./woocommerce";

export const insertShopDiscountCode = async ({
  codeExpirationPeriod,
  apiPayloadDetails,
  shopApiData,
  code,
}: IIssueDiscountCodeShopPayload) => {
  switch (shopApiData.shop_type) {
    case SHOP_PROVIDER.PRESTASHOP:
      return await insertPrestashopDiscountCode({
        codeExpirationPeriod,
        apiPayloadDetails,
        shopApiData,
        code,
      });
    case SHOP_PROVIDER.WOOCOMMERCE:
      return await insertWoocommerceDiscountCode({
        codeExpirationPeriod,
        apiPayloadDetails,
        shopApiData,
        code,
      });
    case SHOP_PROVIDER.SHOPIFY:
      return await insertShopifyDiscountCode({
        codeExpirationPeriod,
        apiPayloadDetails,
        shopApiData,
        code,
      });
    case SHOP_PROVIDER.UPON_DELIVERY:
      return await Promise.resolve(true);
    default:
      throw new Error("Unsupported shop type");
  }
};
