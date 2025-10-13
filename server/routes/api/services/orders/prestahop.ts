import { HTTP_METHOD } from "../../../../shared/types/general";
import {
  IAddressDetails,
  ICartOrderRequestBody,
  ICustomerData,
} from "../../../../shared/types/orders";
import {
  IPrestashopCartDraftData,
  IPrestashopExistingCarData,
} from "../../../../shared/types/shopHandlers/prestashop";
import { IShopApiData } from "../../../../shared/types/synchronization";
import { fetchHandler } from "../../../../shared/utils/fetching";
import {
  buildPrestashopAddressFilterUrl,
  createPrestashopXML,
  getCountryId,
  getCurrencyId,
  getLanguageId,
} from "../../../../shared/utils/shopHandlers/prestashop";

export const createPrestashopCartOrder = async (
  cartOrderData: ICartOrderRequestBody,
  shopApiData: IShopApiData
) => {
  const customerId = await getPrestashopCustomerId(
    cartOrderData.customer_data,
    shopApiData
  );

  if (!customerId) {
    throw new Error("No customer id found");
  }

  const deliveryAddressId = await getPrestashopAddressId(
    cartOrderData.delivery_address_details,
    customerId,
    cartOrderData.customer_data,
    shopApiData
  );

  const invoiceAddressId = await getPrestashopAddressId(
    cartOrderData.invoice_address_details,
    customerId,
    cartOrderData.customer_data,
    shopApiData
  );

  const [currencyId, languageId] = await Promise.all([
    getCurrencyId(
      shopApiData.api_url,
      shopApiData.api_key,
      cartOrderData.currency_code
    ),
    getLanguageId(
      shopApiData.api_url,
      shopApiData.api_key,
      cartOrderData.language_code
    ),
  ]);

  if (!currencyId) {
    throw new Error("No currency id found");
  }

  if (!languageId) {
    throw new Error("No language id found");
  }
  let deliveryMethodId;
  // if (cartOrderData.delivery_uuid) {
  //   deliveryMethodId = await fetchExternalDeliveryOptionId(
  //     cartOrderData.shop_owner_uuid,
  //     cartOrderData.delivery_uuid
  //   );
  // }

  const cartId = await createOrModifyPrestashopCart(
    {
      customerId,
      deliveryAddressId,
      invoiceAddressId,
      currencyId,
      languageId,
      deliveryMethodId,
      products: cartOrderData.products,
    },
    shopApiData
  );

  return cartId;
};

export const getPrestashopCustomerId = async (
  customerData: ICustomerData,
  shopApiData: IShopApiData
) => {
  try {
    const existingCustomer = await fetchHandler(
      `${shopApiData.api_url}/customers?filter[email]=${customerData.email}&output_format=JSON`,
      {
        method: HTTP_METHOD.GET,
        headers: {
          Authorization:
            "Basic " +
            Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
        },
      }
    );

    if (existingCustomer.customers?.length) {
      return existingCustomer.customers[0].id;
    }

    const prestashopCustomerData = {
      customer: {
        firstname: customerData.first_name,
        lastname: customerData.last_name,
        email: customerData.email,
        passwd: customerData.email,
        // default group is client
        id_default_group: 3,
      },
    };
    const prestashopCustomerXML = createPrestashopXML(prestashopCustomerData);
    const response = await fetchHandler(
      `${shopApiData.api_url}/customers?output_format=JSON`,
      {
        method: HTTP_METHOD.POST,
        isXML: true,
        headers: {
          Authorization:
            "Basic " +
            Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
        },
        body: prestashopCustomerXML,
      }
    );

    if (!response.customer) {
      throw new Error("Error creating prestashop customer");
    }

    return +response.customer.id;
  } catch (error) {
    console.log(error);
    return undefined;
  }
};

export const getPrestashopAddressId = async (
  addressDetails: IAddressDetails,
  customerId: number,
  customerData: ICustomerData,
  shopApiData: IShopApiData
) => {
  const countryCode = await getCountryId(
    shopApiData.api_url,
    shopApiData.api_key,
    addressDetails.country
  );

  if (!countryCode) {
    throw new Error("Country not available");
  }

  const prestashopAddressData = {
    address: {
      id_customer: customerId,
      id_country: countryCode,
      alias: "Home",
      firstname: customerData.first_name,
      lastname: customerData.last_name,
      address1: `${addressDetails.street} ${addressDetails.house_number ?? ""}`,
      postcode: addressDetails.post_code,
      city: addressDetails.city,
      phone: customerData.phone_number,
      company: customerData.company_data?.name,
      vat_number: customerData.company_data?.nip,
    },
  };

  const existingAddress = await fetchHandler(
    buildPrestashopAddressFilterUrl(
      shopApiData.api_url,
      prestashopAddressData.address
    ),
    {
      method: HTTP_METHOD.GET,
      headers: {
        Authorization:
          "Basic " + Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
      },
    }
  );

  if (existingAddress.addresses?.length) {
    return existingAddress.addresses[0]?.id;
  }

  const prestashopAddressXML = createPrestashopXML(prestashopAddressData);

  const response = await fetchHandler(
    `${shopApiData.api_url}/addresses?output_format=JSON`,
    {
      method: HTTP_METHOD.POST,
      isXML: true,
      headers: {
        Authorization:
          "Basic " + Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
      },
      body: prestashopAddressXML,
    }
  );

  if (!response.address) {
    throw new Error("Error creating prestashop address");
  }

  return +response.address.id;
};

export const createOrModifyPrestashopCart = async (
  {
    customerId,
    deliveryAddressId,
    invoiceAddressId,
    currencyId,
    languageId,
    deliveryMethodId,
    products,
  }: IPrestashopCartDraftData,
  shopApiData: IShopApiData
) => {
  const prestashopCartDraftData = {
    cart: {
      id_customer: +customerId,
      id_address_delivery: +deliveryAddressId,
      id_address_invoice: +invoiceAddressId,
      id_currency: +currencyId,
      id_lang: +languageId,
      id_carrier: deliveryMethodId ? +deliveryMethodId : undefined,
      delivery_option: deliveryMethodId
        ? JSON.stringify({ [deliveryAddressId]: deliveryMethodId + "," })
        : undefined,
      associations: {
        cart_rows: {
          // weird syntax because xml builder builds like this
          cart_row: products.map((product) => ({
            id_product: product.id,
            id_product_attribute: product.attribute_id,
            quantity: product.quantity,
          })),
        },
      },
    },
  };

  const existingCartData = await getValidExistingCartData(
    customerId,
    shopApiData
  );

  if (
    Object.values(existingCartData).every(
      (item) => item != null && item !== "" && !Number.isNaN(item)
    )
  ) {
    const prestashopCartDraftModifyData = {
      cart: {
        id: +existingCartData.id,
        id_shop: +existingCartData.id_shop,
        id_shop_group: +existingCartData.id_shop_group,
        ...prestashopCartDraftData.cart,
      },
    };
    const prestashopCartDraftXML = createPrestashopXML(
      prestashopCartDraftModifyData
    );

    console.log(prestashopCartDraftXML);

    // change the existing one
    const response = await fetchHandler(
      `${shopApiData.api_url}/carts/${+existingCartData.id}?output_format=JSON`,
      {
        method: HTTP_METHOD.PUT,
        isXML: true,
        headers: {
          Authorization:
            "Basic " +
            Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
        },
        body: prestashopCartDraftXML,
      }
    );

    if (!response.cart) {
      throw new Error("Error updating prestashop cart");
    }

    return +response.cart.id;
  } else {
    // create new
    const prestashopCartDraftXML = createPrestashopXML(prestashopCartDraftData);
    const response = await fetchHandler(
      `${shopApiData.api_url}/carts?output_format=JSON`,
      {
        method: HTTP_METHOD.POST,
        isXML: true,
        headers: {
          Authorization:
            "Basic " +
            Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
        },
        body: prestashopCartDraftXML,
      }
    );

    if (!response.cart) {
      throw new Error("Error creating prestashop cart");
    }

    return +response.cart.id;
  }
};

export const getValidExistingCartData = async (
  customerId: number,
  shopApiData: IShopApiData
): Promise<IPrestashopExistingCarData> => {
  const existingCart = await fetchHandler(
    `${shopApiData.api_url}/carts?filter[id_customer]=${customerId}&display=[id,id_shop, id_shop_group]&output_format=JSON`,
    {
      method: HTTP_METHOD.GET,
      headers: {
        Authorization:
          "Basic " + Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
      },
    }
  );

  let existingValidCartData;

  if (existingCart.carts?.length) {
    existingValidCartData = existingCart.carts[existingCart.carts.length - 1];
  }

  if (existingValidCartData?.id) {
    // check if an order has been already created for the cart
    const existingCartOrder = await fetchHandler(
      `${shopApiData.api_url}/orders?filter[id_cart]=${existingValidCartData.id}&output_format=JSON`,
      {
        method: HTTP_METHOD.GET,
        headers: {
          Authorization:
            "Basic " +
            Buffer.from(`${shopApiData.api_key}:`).toString("base64"),
        },
      }
    );

    if (existingCartOrder.orders?.length) {
      existingValidCartData = undefined;
    }
  }

  return existingValidCartData;
};
