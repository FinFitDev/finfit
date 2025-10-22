import { IShopApiData } from "../integrations";

export interface IIssueDiscountCodeShopPayload {
  code: string;
  shopApiData: IShopApiData;
  apiPayloadDetails: Record<string, string>; // details for the discount such as discount value and restrictions (JSON)
  codeExpirationPeriod: number;
}
