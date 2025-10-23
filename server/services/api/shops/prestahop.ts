import { HTTP_METHOD } from "../../../shared/types/general";
import { IShopApiData } from "../../../shared/types/integrations";
import { IIssueDiscountCodeShopPayload } from "../../../shared/types/integrations/general";
import { IPrestashopDiscountCodeInsert } from "../../../shared/types/integrations/prestashop";
import { fetchHandler } from "../../../shared/utils/fetching";
import {
  createPrestashopXML,
  formatDateForPrestashop,
} from "../../../shared/utils/integrations/prestashop";

export const insertPrestashopDiscountCode = async ({
  codeExpirationPeriod,
  apiPayloadDetails,
  shopApiData,
  code,
}: IIssueDiscountCodeShopPayload) => {
  try {
    const validUntil = new Date(Date.now() + +codeExpirationPeriod);
    const now = new Date();

    const payload: IPrestashopDiscountCodeInsert = {
      cart_rule: {
        name: {
          language: {
            _id: 1,
            value: "DISCOUNT_CODE_FINFIT",
          },
        },
        description: "description",
        code,
        active: 1,
        quantity: 1,
        quantity_per_user: 1,
        date_from: formatDateForPrestashop(now),
        date_to: formatDateForPrestashop(validUntil),
        ...apiPayloadDetails,
      },
    };

    const username = shopApiData.api_key;
    const password = "";
    const url = shopApiData.api_url;

    const authHeader =
      "Basic " + Buffer.from(`${username}:${password}`).toString("base64");

    const xmlPayload = createPrestashopXML(payload);

    console.log(xmlPayload);

    const response = await fetchHandler(
      `${url}/cart_rules?output_format=JSON`,
      {
        method: HTTP_METHOD.POST,
        headers: {
          Authorization: authHeader,
        },
        body: xmlPayload,
        isXML: true,
      }
    );

    if (!response || !response?.cart_rule) {
      throw new Error("Response failed");
    }

    return response;
  } catch (error) {
    console.log("Error inserting code to prestashop");
    throw error;
  }
};
