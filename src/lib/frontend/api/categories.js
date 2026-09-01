import { fetchJson } from "./_http.js";

export async function fetchCategory(slug, { locale } = {}) {
  return fetchJson(`/api/categories/${slug}`, { locale });
}

export async function fetchProductsByCategory(slug, { locale, page, perPage } = {}) {
  return fetchJson(`/api/products`, { locale, category: slug, page, perPage });
}