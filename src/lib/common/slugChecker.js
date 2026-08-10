// src/lib/common/slugChecker.js
export function normalizeSlug(slug, type = "default") {
  if (!slug) return "#";

  let clean = slug.replace(/^\/+|\/+$/g, "");

  if (type === "news") {
    if (clean.startsWith("news/")) return `/${clean}/`;
    return `/news/${clean}/`;
  }

  if (type === "articles" || type === "stati") {
    if (clean.startsWith("stati/")) return `/${clean}/`;
    return `/stati/${clean}/`;
  }

  if (type === "product") {
    if (clean.startsWith("produkciya/")) return `/${clean}/`;
    return `/produkciya/${clean}/`;
  }

  return `/${clean}/`;
}
