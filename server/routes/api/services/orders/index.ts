import { fetchProductOwnerAPIById } from "../../../../models/partnerModel";
import { ICartOrderRequestBody } from "../../../../shared/types/orders";
import {
  IShopApiData,
  SHOP_PROVIDER,
} from "../../../../shared/types/synchronization";
import { decryptShopApiParams } from "../../../../shared/utils";
import { createPrestashopCartOrder } from "./prestahop";
export const handleCreateCartOrders = async (
  ordersRequest: ICartOrderRequestBody[]
) => {
  const createdCartOrders = [];

  const ownerDataResponses = await Promise.all(
    ordersRequest.map((order) =>
      fetchProductOwnerAPIById(order.shop_owner_uuid)
    )
  );

  const decryptedOwners = ownerDataResponses.map(decryptShopApiParams);

  for (let i = 0; i < ordersRequest.length; i++) {
    const orderData = ordersRequest[i];
    const productOwnersDecrypted = decryptedOwners[i];

    switch (productOwnersDecrypted[0].shop_type) {
      case SHOP_PROVIDER.PRESTASHOP:
        createdCartOrders.push(
          await createPrestashopCartOrder(orderData, productOwnersDecrypted[0])
        );
        break;
    }
  }

  return createdCartOrders;
};
