import { buildPage } from "$lib/server/api/pageBuilder.js";
import { error } from "@sveltejs/kit";
import { dlog } from "$lib/common/dlog.js";

export const load = async ({ params, url }) => {
  const raw = params.slug || "";
  const clean = raw.replace(/^\/+|\/+$/g, "");
  const canonical = clean === "" ? "/" : `/${clean}/`;
  const filter = `slug="${clean}" || slug="${canonical}"`;

  const currentPage = parseInt(url.searchParams.get("page") || "1", 10);
  const categorySlug = url.searchParams.get("category") || null;

  dlog("ROUTE", "Request", { clean, canonical, filter, currentPage, categorySlug });

  try {
    const pageData = await buildPage(filter, clean, currentPage, categorySlug);
    
    if (pageData?.page?.raw?.display_date) {
      pageData.page.display_date = pageData.page.raw.display_date;
    }

    return { pageData, currentPage };
  } catch (err) {
    dlog("ROUTE-ERR", "404", { url: url.pathname, error: err.message });
    throw error(404, `Page not found: ${url.pathname} | Reason: ${err.message}`);
  }
};