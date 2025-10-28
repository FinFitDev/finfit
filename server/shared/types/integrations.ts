export enum SHOP_PROVIDER {
  PRESTASHOP = "prestashop",
  WOOCOMMERCE = "woocommerce",
}

export interface IShopApiData {
  uuid: string;
  api_key?: string;
  api_url: string;
  shop_type: SHOP_PROVIDER;
  consumer_key?: string;
  consumer_secret?: string;
}
