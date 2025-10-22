export enum SHOP_PROVIDER {
  PRESTASHOP = "prestashop",
}

export interface IShopApiData {
  uuid: string;
  api_key: string;
  api_url: string;
  shop_type: SHOP_PROVIDER;
}
