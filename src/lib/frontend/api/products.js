// src/lib/frontend/api/products.js
import { fetchJson } from "./_http.js";

export async function fetchProducts({ locale, page, perPage } = {}) {
  return fetchJson("/api/products", { locale, page, perPage });
}
