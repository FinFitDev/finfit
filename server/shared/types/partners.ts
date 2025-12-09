import { SHOP_PROVIDER } from "./integrations";

export interface IPartnerInsertPayload {
  name: string;
  description: string;
  apiKey: string;
  apiUrl: string;
  shopType: SHOP_PROVIDER;
}
