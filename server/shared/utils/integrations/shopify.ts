import crypto from "crypto";
import { IShopifyInitQuery } from "../../types/integrations/shopify";
import { IShopApiData } from "../../types/integrations";
import { fetchHandler } from "../fetching";
import { HTTP_METHOD } from "../../types/general";
import { IIssueDiscountCodeShopPayload } from "../../types/integrations/general";

export function verifyShopifyHmac(
  query: IShopifyInitQuery,
  clientSecret: string
) {
  const { hmac, ...params } = query;

  const message = Object.keys(params)
    .sort()
    .map(
      (key) => `${key}=${params[key as keyof Omit<IShopifyInitQuery, "hmac">]}`
    )
    .join("&");

  const generatedHmac = crypto
    .createHmac("sha256", clientSecret)
    .update(message)
    .digest("hex");

  const generatedBytes = Uint8Array.from(Buffer.from(generatedHmac, "hex"));
  const receivedBytes = Uint8Array.from(Buffer.from(hmac, "hex"));

  return (
    generatedBytes.length === receivedBytes.length &&
    crypto.timingSafeEqual(generatedBytes, receivedBytes)
  );
}

export const getShopifyAccessToken = async ({
  code,
  shop,
}: {
  code: string;
  shop: string;
}) => {
  const clientSecret = process.env.SHOPIFY_API_SECRET;
  const clientId = process.env.SHOPIFY_API_KEY;

  const tokenRes = await fetch(`https://${shop}/admin/oauth/access_token`, {
    method: HTTP_METHOD.POST,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      client_id: clientId,
      client_secret: clientSecret,
      code,
    }),
  });

  const tokenData = await tokenRes.json();
  const accessToken = tokenData.access_token;

  if (!accessToken) {
    throw new Error("Invalid access token");
  }

  return accessToken;
};

export const createShopifyWebhook = async ({
  shop,
  apiKey,
}: {
  shop: string;
  apiKey: string;
}) => {
  const webhookPayload = {
    webhook: {
      topic: "discounts/update",
      address:
        "https://finfit-server-214505318022.europe-west1.run.app/webhook/shopify",
      format: "json",
    },
  };

  const responseWebhookCreate = await fetchHandler(
    `https://${shop}/admin/api/2025-10/webhooks.json`,
    {
      method: HTTP_METHOD.POST,
      headers: {
        "X-Shopify-Access-Token": apiKey,
      },
      body: webhookPayload,
    }
  );

  return responseWebhookCreate;
};

export const createShopifyPriceRule = async ({
  codeExpirationPeriod,
  apiPayloadDetails,
  shopApiData,
}: Omit<IIssueDiscountCodeShopPayload, "code">) => {
  const validFrom = new Date().toISOString();
  const validUntil = new Date(
    Date.now() + Number(codeExpirationPeriod)
  ).toISOString();

  const discountBasePayload = {
    price_rule: {
      title: `FINFIT_PARTNER_DISCOUNT_${shopApiData.api_url}`,
      target_type: "line_item",
      starts_at: validFrom,
      ends_at: validUntil,
      once_per_customer: true, // only one use per customer
      usage_limit: 1, // only one total use per customer
      ...apiPayloadDetails,
    },
  };

  const responseDiscountBase = await fetchHandler(
    `https://${shopApiData.api_url}/admin/api/2025-10/price_rules.json`,
    {
      method: HTTP_METHOD.POST,
      headers: {
        "X-Shopify-Access-Token": shopApiData.api_key!,
      },

      body: discountBasePayload,
    }
  );

  return responseDiscountBase;
};

export const createShopifyDiscountCodeForPriceRule = async ({
  priceRuleId,
  code,
  shopApiData,
}: {
  priceRuleId: number;
  code: string;
  shopApiData: IShopApiData;
}) => {
  const payload = {
    discount_code: {
      code,
    },
  };

  const response = await fetchHandler(
    `https://${shopApiData.api_url}/admin/api/2025-10/price_rules/${priceRuleId}/discount_codes.json`,
    {
      method: HTTP_METHOD.POST,
      headers: {
        "X-Shopify-Access-Token": shopApiData.api_key!,
      },
      body: payload,
    }
  );

  return response.discount_code;
};

export const getShopifyDiscountDetails = async (
  id: string,
  apiKey: string,
  shopUrl: string
) => {
  const query = `
query GetDiscountUsage($id: ID!) {
  codeDiscountNode(id: $id) {
    id
    codeDiscount {
      ... on DiscountCodeBasic {
        title
        asyncUsageCount
        codes(first: 10) {
          nodes {
            id
            code
          }
        }
      }
    }
  }
}
  `;

  const variables = { id };

  const response = await fetch(
    `https://${shopUrl}/admin/api/2025-10/graphql.json`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Shopify-Access-Token": apiKey,
      },
      body: JSON.stringify({ query, variables }),
    }
  );

  if (!response.ok) {
    const text = await response.text();
    throw new Error("Shopify GraphQL error: " + text);
  }

  const result = await response.json();

  if (result.errors) {
    throw new Error("GraphQL errors: " + JSON.stringify(result.errors));
  }
  const usageCount =
    result.data?.codeDiscountNode?.codeDiscount?.asyncUsageCount;
  const code =
    result.data?.codeDiscountNode?.codeDiscount?.codes?.nodes?.[0]?.code;
  if (!code) {
    throw new Error("No discount code found");
  }

  if (usageCount === 0) {
    throw new Error("Discount not used yet");
  }

  return code;
};
