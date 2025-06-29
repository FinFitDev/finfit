import { HTTP_METHOD } from "../../types/general";
import { fetchHandler } from "../fetching";
import { createXMLFromJSON } from "../parsers";

export const createPrestashopXML = (jsonData: Record<string, any>) => {
  return `<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">${createXMLFromJSON(
    jsonData
  )}</prestashop>
`;
};

export function buildPrestashopAddressFilterUrl(
  apiUrl: string,
  address: Record<string, any>
): string {
  const params = new URLSearchParams();

  for (const [key, value] of Object.entries(address)) {
    if (key === "alias" || value == null || value === "") continue;

    // PrestaShop filter syntax
    params.append(`filter[${key}]`, `[${value}]`);
  }

  params.append("output_format", "JSON");

  return `${apiUrl}/addresses?${params.toString()}`;
}

export const getCountryId = async (
  apiUrl: string,
  apiKey: string,
  countryCode: string
) => {
  const availableCountries: { countries: { id: number; iso_code: string }[] } =
    await fetchHandler(
      `${apiUrl}/countries?filter[active]=1&output_format=JSON&display=[id,iso_code]`,
      {
        method: HTTP_METHOD.GET,
        headers: {
          Authorization:
            "Basic " + Buffer.from(`${apiKey}:`).toString("base64"),
        },
      }
    );

  return (availableCountries?.countries ?? []).find(
    (entry) => entry.iso_code == countryCode
  )?.id;
};

export const getCurrencyId = async (
  apiUrl: string,
  apiKey: string,
  currencyCode: string
) => {
  const availableCurrencies: {
    currencies: { id: number; iso_code: string }[];
  } = await fetchHandler(
    `${apiUrl}/currencies?filter[active]=1&output_format=JSON&display=[id,iso_code]`,
    {
      method: HTTP_METHOD.GET,
      headers: {
        Authorization: "Basic " + Buffer.from(`${apiKey}:`).toString("base64"),
      },
    }
  );

  return (availableCurrencies?.currencies ?? []).find(
    (entry) => entry.iso_code == currencyCode
  )?.id;
};

export const getLanguageId = async (
  apiUrl: string,
  apiKey: string,
  languageCode: string
) => {
  const availableLanguages: {
    languages: { id: number; iso_code: string }[];
  } = await fetchHandler(
    `${apiUrl}/languages?filter[active]=1&output_format=JSON&display=[id,iso_code]`,
    {
      method: HTTP_METHOD.GET,
      headers: {
        Authorization: "Basic " + Buffer.from(`${apiKey}:`).toString("base64"),
      },
    }
  );

  return (availableLanguages?.languages ?? []).find(
    (entry) => entry.iso_code == languageCode
  )?.id;
};
