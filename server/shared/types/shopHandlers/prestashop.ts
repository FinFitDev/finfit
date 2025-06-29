import { IProductRow } from "../orders";

export interface IPrestashopCartDraftData {
  customerId: number;
  deliveryAddressId: number;
  invoiceAddressId: number;
  currencyId: number;
  languageId: number;
  deliveryMethodId?: number;
  products: IProductRow[];
}

export interface IPrestashopExistingCarData {
  id: number;
  id_shop: string;
  id_shop_group: string;
}
