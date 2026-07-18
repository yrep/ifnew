// src/lib/common/csvParser.js

export function parseCsvData(dataString) {
  if (!dataString || typeof dataString !== "string") return {};

  const result = {};
  const lines = dataString.split("\n");

  for (const line of lines) {
    const trimmedLine = line.trim();
    if (!trimmedLine) continue;

    const separatorIndex = trimmedLine.indexOf(";");
    if (separatorIndex > -1) {
      const key = trimmedLine.substring(0, separatorIndex).trim();
      const value = trimmedLine.substring(separatorIndex + 1).trim();
      if (key && value) {
        result[key] = value;
      }
    }
  }
  return result;
}
