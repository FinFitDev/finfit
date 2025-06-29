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
      xml += `<${key}>${createXMLFromJSON(value)}</${key}>`;
    } else {
      xml += `<${key}>${value}</${key}>`;
    }
  }

  return xml;
};
