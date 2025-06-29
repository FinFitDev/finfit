export const updateProductQuantitiesHandler = () => {};

import nodeCron from "node-cron";
import { DEFAULT_ALL_SHOPS_OBJECT } from "../../../../shared/constants";
import {
  fetchProductOwnersWithAvailableAPI,
  updateStockFromAllShops,
} from "../../../../models/synchronizationModel";
import { decryptShopApiParams } from "../../../../shared/utils";

import { synchronizePrestashopQuantities } from "./shopIntegrationsService";
import {
  IAllShops,
  IShopApiData,
  SHOP_PROVIDER,
} from "../../../../shared/types/synchronization";

export const synchronizeQuantities = async () => {
  try {
    const productOwners: IShopApiData[] =
      await fetchProductOwnersWithAvailableAPI();

    // decrypt api keys
    const productOwnersDecrypted = decryptShopApiParams(productOwners);

    const allShops: IAllShops = DEFAULT_ALL_SHOPS_OBJECT;

    for (const shop of productOwnersDecrypted) {
      switch (shop.shop_type) {
        case SHOP_PROVIDER.PRESTASHOP:
          const shopData = await synchronizePrestashopQuantities(
            shop.api_url,
            shop.api_key,
            shop.uuid
          );

          allShops[SHOP_PROVIDER.PRESTASHOP]![shop.uuid] = shopData;
          break;
      }
    }

    await updateStockFromAllShops(allShops);
  } catch (error) {
    console.log("Failed to synchronize");
  }
};

// Setup cron
nodeCron.schedule("*/10 * * * *", () => {
  console.log("running");
  synchronizeQuantities();
});
