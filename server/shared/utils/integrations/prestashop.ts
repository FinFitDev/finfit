import { createXMLFromJSON } from "../parsers";

export const createPrestashopXML = (jsonData: Record<string, any>) => {
  return `<?xml version="1.0" encoding="UTF-8"?>
<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">${createXMLFromJSON(
    jsonData
  )}</prestashop>
`;
};
export const formatDateForPrestashop = (date: Date): string => {
  const pad = (n: number) => n.toString().padStart(2, "0");
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(
    date.getDate()
  )} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(
    date.getSeconds()
  )}`;
};
