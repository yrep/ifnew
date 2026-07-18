// src/lib/common/routes.js
import { config } from "$lib/common/config.js";

export const mainPages = config.settings.menu.header;

export function isActivePage(currentPath, pageSlug) {
  if (pageSlug === "/") return currentPath === "/";
  return currentPath.startsWith(pageSlug);
}
