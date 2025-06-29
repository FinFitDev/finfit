import axios from "axios";
import { convertStockListToProducts } from "../../../../shared/utils";
import { StockItem } from "../../../../shared/types/synchronization";

export const synchronizePrestashopQuantities = async (
  shopUrl: string,
  apiKey: string,
  uuid: string
) => {
  try {
    const endpoint = `${shopUrl}/stock_availables`;

    const response = await axios.get(endpoint, {
      headers: {
        Accept: "application/json",
      },
      auth: {
        username: apiKey,
        password: "", // PrestaShop uses HTTP Basic Auth with empty password
      },
      params: {
        display: "[id,id_product,id_product_attribute,quantity]",
        output_format: "JSON", // force JSON response
        // "filter[id_product]": "[19|20]",
      },
    });

    const items = response.data.stock_availables;

    const quantities: StockItem[] = items.map((item: any) => ({
      id: +item.id,
      productId: +item.id_product,
      idProductAttribute: +item.id_product_attribute,
      quantity: +item.quantity,
    }));

    return convertStockListToProducts(quantities);
  } catch (error: any) {
    console.error(
      "Failed to synchronize PrestaShop quantities:",
      error?.response?.data || error.message
    );
    throw error;
  }
};
