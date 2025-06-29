export interface ICustomerData {
  first_name: string;
  last_name: string;
  email: string;
  phone_number: string;
  company_data?: {
    name: string;
    nip: number;
  };
}

export interface IAddressDetails {
  country: string;
  city: string;
  street: string;
  post_code: string;
  house_number?: string;
  flat_number?: string;
  province?: string;
}

export interface IProductRow {
  id: string;
  attribute_id: string;
  quantity: number;
}

export interface ICartOrderRequestBody {
  shop_owner_uuid: string;
  customer_data: ICustomerData;
  delivery_address_details: IAddressDetails;
  invoice_address_details: IAddressDetails;
  currency_code: string;
  language_code: string;
  //   uuid from db
  delivery_uuid: string;
  products: IProductRow[];
}
