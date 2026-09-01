import { error } from "@sveltejs/kit";
import PocketBase from "pocketbase";
import { config } from "$lib/common/config.js";
import { buildPage } from "$lib/server/api/pageBuilder.js";
import { getFullFileUrl } from "$lib/common/fileUtils.js";
import { dlog } from "$lib/common/dlog.js";

export const load = async ({ params, url }) => {
  const raw = params.slug || "";
  const clean = raw.replace(/^\/+|\/+$/g, "");
  const canonical = clean === "" ? "/" : `/${clean}/`;
  const filter = `slug="${clean}" || slug="${canonical}"`;

  const currentPage = parseInt(url.searchParams.get("page") || "1", 10);
  const categorySlug = url.searchParams.get("category") || null;

  try {
    const pageData = await buildPage(filter, clean, currentPage, categorySlug);
    if (pageData?.page?.raw?.display_date) {
      pageData.page.display_date = pageData.page.raw.display_date;
    }
    return { pageData, currentPage };
  } catch (err) {
    dlog("ROUTE-INFO", "Page not found, trying category", { clean, error: err.message });

    const pb = new PocketBase(config.pocketbase.url);
    try {
      const category = await pb.collection("product_categories").getFirstListItem(`slug="${clean}"`);
      const products = await pb.collection("products").getFullList({
        filter: `category = "${category.id}"`,
        sort: "order,updated",
      });

      const section = {
        id: `category-products-${category.id}`,
        expand: {
          section: {
            type: "products",
            code: "products_simple_list",
            heading: category.name,
            excerpt: "",
            show_heading_excerpt: false,
          },
        },
        items: products,
        totalPages: 1,
        parsedData: {},
      };

      const pageData = {
        page: {
          title: category.name,
          html: category.description || "",
          image: category.image ? getFullFileUrl({ ...category, collectionName: 'product_categories' }, 'image') : null,
          alt: category.image_alt || category.name,
          raw: { collectionName: "product_categories", ...category },
          display_date: null,
        },
        beforeContent: [],
        betweenContent: [],
        afterContent: [section],
      };

      return { pageData, currentPage };
    } catch (catErr) {
      dlog("ROUTE-ERR", "Category not found", { url: url.pathname, error: catErr.message });
      throw error(404, `Page not found: ${url.pathname}`);
    }
  }
};