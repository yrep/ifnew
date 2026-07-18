// src/lib/frontend/api/pages.js
import { buildUrl } from "./_http.js";

export async function fetchPage({ slug, locale = "ru" } = {}) {
  const res = await fetch(buildUrl(`/api/pages`, { slug, locale }));
  if (!res.ok) throw new Error("Failed to load page");
  return res.json();
}

