import { buildPage } from "$lib/server/api/pageBuilder.js";
import { error } from "@sveltejs/kit";
import { dlog } from "$lib/common/dlog.js";

export const load = async ({ params, url }) => {
  const raw = params.slug || "";
  const clean = raw.replace(/^\/+|\/+$/g, "");
  const canonical = clean === "" ? "/" : `/${clean}/`;
  const filter = `slug="${clean}" || slug="${canonical}"`;

  const currentPage = parseInt(url.searchParams.get("page") || "1", 10);

  dlog("ROUTE", "📍 Запрос", { url: url.pathname, clean, filter, currentPage });

    try {
    const pageData = await buildPage(filter, clean, currentPage);
    
    if (pageData?.page?.raw?.display_date) {
      pageData.page.display_date = pageData.page.raw.display_date;
    }

    return { pageData, currentPage };
  } catch (err) {
    dlog("ROUTE-ERR", "❌ 404", { url: url.pathname, error: err.message });
    throw error(404, `Страница не найдена: ${url.pathname}`);
  }
};
