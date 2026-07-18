import { config } from "$lib/common/config.js";

const baseUrl = (config.pocketbase.filesUrl || "http://127.0.0.1:8090").replace(/\/$/, "");

export function enrichFileUrls(data) {
  if (!data) return data;

  if (Array.isArray(data)) {
    return data.map(item => enrichFileUrls(item));
  }

  if (typeof data === "object") {
    const enriched = { ...data };

    const collection = enriched.collectionName || "unknown";
    const recordId = enriched.id || "";

    for (const key in enriched) {
      if ((key === "image" || key === "logo") && typeof enriched[key] === "string" && enriched[key].length > 0) {
        if (!enriched[key].startsWith("http")) {
          enriched[key] = `${baseUrl}/api/files/${collection}/${recordId}/${enriched[key]}`;
        }
      }
      else if (typeof enriched[key] === "object" && enriched[key] !== null) {
        enriched[key] = enrichFileUrls(enriched[key]);
      }
    }
    return enriched;
  }

  return data;
}
