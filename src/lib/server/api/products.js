// src/lib/server/api/products.js
import { pb } from "$lib/server/pocketbase.js";
import { config } from "$lib/common/config.js";
import { t } from "$lib/common/translations.js";
import { dlog } from "$lib/common/dlog.js";

export async function getProducts({
  locale = "ru",
  page = 1,
  perPage = config.settings.entities.products.perPage,
}) {
  try {
    dlog("API", "🔍 Запрос товаров", { page, perPage });

    const result = await pb.collection("products").getList(page, perPage, {
      sort: "order,created",
    });

    dlog("API", "✅ Товары получены", { total: result.totalItems });

    return {
      items: result.items.map((item) => ({
        id: item.id,
        slug: item.slug,
        title: item.name || item.alternative_name || "Товар",
        excerpt: item.excerpt,
        description: item.description,
        image: item.image ? pb.files.getUrl(item, item.image) : null,
      })),
      page: result.page,
      perPage: result.perPage,
      total: result.totalItems,
      totalPages: result.totalPages,
    };
  } catch (err) {
    dlog("API-ERR", "❌ Ошибка товаров", { message: err.message });
    throw new Error(t("errors.loadProductsError", locale));
  }
}
