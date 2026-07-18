// src/routes/[...slug]/+page.server.js
import { buildPage } from "$lib/server/api/pageBuilder.js";
import { error } from "@sveltejs/kit";
import { dlog } from "$lib/common/dlog.js";

export const load = async ({ params, url }) => {
  const raw = params.slug || "";
  const clean = raw.replace(/^\/+|\/+$/g, "");
  const canonical = clean === "" ? "/" : `/${clean}/`;

  const variants = [
    ...new Set([canonical, clean, raw].filter((v) => v && v !== "undefined")),
  ];
  const filter = variants.map((v) => `slug="${v}"`).join(" || ");

  dlog("ROUTE", `📍 Запрос URL`, { browser_url: url.pathname, filter });

  try {
    const pageData = await buildPage(filter);
    dlog("ROUTE", `✅ Успешно загружено`, {
      slug: pageData.page.slug,
      isEntity: pageData.page.isEntity,
    });
    return { pageData };
  } catch (err) {
    dlog("ROUTE-ERR", `❌ 404 Не найдено`, { filter, error: err.message });
    throw error(404, `Страница не найдена`);
  }
};
