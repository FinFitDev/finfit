import WooCommerceRestApi from "@woocommerce/woocommerce-rest-api";
import { IShopApiData } from "../../types/integrations";

export const getWooCommerceRestApi = (shopApiParams: IShopApiData) => {
  return new WooCommerceRestApi({
    url: shopApiParams.api_url,
    consumerKey: shopApiParams.consumer_key!,
    consumerSecret: shopApiParams.consumer_secret!,
    version: "wc/v3",
    //   queryStringAuth: true // Force SSL
  });
};

export const formatDateForWooCommerce = (date: Date): string => {
  const pad = (n: number) => n.toString().padStart(2, "0");
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(
    date.getDate()
  )}`;
};
