export enum SHOP_PROVIDER {
  PRESTASHOP = "prestashop",
}

export interface IShopApiData {
  uuid: string;
  api_key: string;
  api_url: string;
  shop_type: SHOP_PROVIDER;
}

export type StockItem = {
  id: number;
  productId: number;
  idProductAttribute: number;
  quantity: number;
};

export interface IProductQuantitiesData {
  productId: string;
  quantity: number;
  variants: {
    variantId: string;
    quantity: number;
  }[];
}

export type IAllShops = Record<
  SHOP_PROVIDER,
  Record<string, IProductQuantitiesData[]>
>;
