import { config } from "$lib/common/config.js";

export function getFullFileUrl(record, fieldName) {
  if (!record || !record[fieldName]) return null;
  const fileName = record[fieldName];
  if (fileName.startsWith("http")) return fileName;

  const baseUrl = (config.pocketbase.filesUrl || "http://127.0.0.1:8090").replace(/\/$/, "");
  const collection = record.collectionName || "unknown";
  return `${baseUrl}/api/files/${collection}/${record.id}/${fileName}`;
}

export function getAltText(record, fallbackFields = ['title', 'name', 'heading']) {
  if (!record) return '';
  
  if (record.image_alt && String(record.image_alt).trim()) {
    return String(record.image_alt).trim();
  }
  
  for (const field of fallbackFields) {
    if (record[field] && String(record[field]).trim()) {
      return String(record[field]).trim();
    }
  }
  
  return '';
}