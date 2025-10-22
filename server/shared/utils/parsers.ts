import { omitKey } from "../utils";

export const createXMLFromJSON = (jsonData: Record<string, any>): string => {
  let xml = "";

  for (const key in jsonData) {
    if (!jsonData.hasOwnProperty(key)) continue;

    const value = jsonData[key];
    if (value === undefined || value === null) continue;

    if (Array.isArray(value)) {
      for (const item of value) {
        // repeat tag for each array item
        xml += `<${key}>${createXMLFromJSON(item)}</${key}>`;
      }
    } else if (typeof value === "object") {
      const attributeField = Object.entries(value).find((k) =>
        k[0].startsWith("_")
      );
      if (attributeField && "value" in value) {
        xml += `<${key} ${attributeField[0].slice(1)}='${attributeField[1]}'>${
          value.value
        }</${key}>`;
      } else {
        xml += `<${key}>${createXMLFromJSON(value)}</${key}>`;
      }
    } else {
      xml += `<${key}>${value}</${key}>`;
    }
  }

  return xml;
};
