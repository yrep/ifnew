// src/routes/sitemap/+page.server.js
import { pb } from "$lib/server/pocketbase.js";
import { dlog } from "$lib/common/dlog.js";

function normalizeSlug(slug) {
  if (!slug) return "/";
  const clean = slug.replace(/^\/+|\/+$/g, "");
  return clean === "" ? "/" : `/${clean}/`;
}

export const load = async () => {
  dlog("SITEMAP", "🗺️ Сбор данных для карты сайта");

  try {
    const pages = await pb.collection("pages").getFullList({
      filter: 'status="published"',
      sort: "created",
    });

    const products = await pb
      .collection("products")
      .getFullList({ sort: "name" });
    const news = await pb.collection("news").getFullList({ sort: "-created" });
    const articles = await pb
      .collection("articles")
      .getFullList({ sort: "-created" });

    const sitemap = pages.map((page) => {
      const node = {
        title: page.heading || page.meta_title || "Без названия",
        slug: normalizeSlug(page.slug),
        children: [],
      };

      if (page.slug.includes("produkciya")) {
        node.children = products.map((p) => ({
          title: p.name || p.heading || "Товар",
          slug: normalizeSlug(p.slug),
        }));
      }
      else if (page.slug.includes("news")) {
        node.children = news.map((n) => ({
          title: n.heading || n.meta_title || "Новость",
          slug: normalizeSlug(n.slug),
        }));
      }
      else if (page.slug.includes("stati")) {
        node.children = articles.map((a) => ({
          title: a.heading || a.meta_title || "Статья",
          slug: normalizeSlug(a.slug),
        }));
      }

      return node;
    });

    return { sitemap };
  } catch (err) {
    dlog("SITEMAP-ERR", "❌ Ошибка сбора карты сайта", err);
    return { sitemap: [] };
  }
};
