import { IOffer, IUser } from "../types";

export enum ORDER_TYPE {
  ASCENDING = "ASCENDING",
  DESCENDING = "DESCENDING",
}

export interface IProductVariant {
  id: string;
  discount: number;
  price: number;
  in_stock: number;
  // indices of images in images array of the product
  images?: number[];
  attributes: Record<string, string>;
}

export interface IProduct {
  uuid: string;
  name: string;
  description: string;
  product_owner: IProductOwner;
  original_price: number;
  finpoints_price: number;
  discount: number;
  created_at: string;
  link?: string;
  images: string[];
  category: string;
  total_transactions: number;
  isAffordable?: boolean;
  variants: IProductVariant[];
  unavailable_delivery_methods?: string[];
  is_digital?: boolean;
}

export interface IProductOwner {
  uuid: string;
  name: string;
  description: string;
  createdAt: string;
  total_transactions: number;
  total_products: number;
  banner_image?: string;
  link?: string;
  image?: string;
  delivery_methods?: IDeliveryMethod[];
}

export interface IDeliveryMethod {
  uuid: string;
  name: string;
  image?: string;
  description?: string;
}

export interface ITransactionEntryResponse {
  uuid: number;
  created_at: string;
  amount_finpoints?: number;
  second_users?: Partial<IUser>[];
  products?: IProduct[];
  user_id?: number;
}

export interface IProductTransactionData {
  variant_id?: string;
  quantity: number;
  eligible?: boolean;
  id: string;
}

export interface ITransactionInsert {
  amount_finpoints: number;
  user_id: string;
  second_user_ids?: string[];
  product_data?: IProductTransactionData[];
}

export interface IFiltersQuery {
  search?: string;
  category?: string;
  min_price?: number;
  max_price?: number;
  min_finpoints?: number;
  max_finpoints?: number;
  sort_by?: string;
  order?: ORDER_TYPE;
  limit?: number;
  offset?: number;
}

export interface IClaim {
  code: string;
  created_at: string;
  valid_until: string;
  offer: IOffer;
}
