import { pb } from "$lib/server/pocketbase.js";
import { dlog } from "$lib/common/dlog.js";
import { parseCsvData } from "$lib/common/csvParser.js";
import { config } from "$lib/common/config.js";
import { getFullFileUrl, getAltText } from "$lib/common/fileUtils.js";

export async function buildPage(filter, cleanSlug, currentPage = 1) {
  dlog("PB", "🔍 Поиск", { filter, cleanSlug, currentPage });

  try {
    const parts = cleanSlug
      ? cleanSlug.split("/").filter((p) => p.length > 0)
      : [];
    const level = parts.length;

    if (level <= 1) {
      dlog("PB", "📄 1 уровень: ищем ТОЛЬКО в CMS");
      const publishedFilter = `(${filter}) && status="published"`;
      const page = await pb.collection("pages").getFirstListItem(publishedFilter);

      dlog("PB", "✅ CMS найдена", { heading: page.heading, slug: page.slug });
      return await formatPageResponse(page, currentPage);
    }

    dlog("PB", "📦 2 уровень: ищем ТОЛЬКО в сущностях");
    const lastPart = parts[parts.length - 1];
    let collectionName = null;

    if (cleanSlug.includes("news")) collectionName = "news";
    else if (cleanSlug.includes("produkciya")) collectionName = "products";
    else if (cleanSlug.includes("stati")) collectionName = "articles";

    if (!collectionName) {
      throw new Error("Неизвестный раздел для сущности");
    }

    const entity = await pb.collection(collectionName).getFirstListItem(`slug~"${lastPart}"`);
    dlog("PB", "✅ Сущность найдена", { heading: entity.heading, slug: entity.slug });

    return formatEntityResponse(entity, collectionName);
  } catch (err) {
    dlog("PB-ERR", "❌ Ошибка", { message: err.message });
    throw new Error("Не удалось загрузить страницу: " + err.message);
  }
}

async function formatPageResponse(page, currentPage) {
  const pageSections = await pb.collection("page_sections").getFullList({
    filter: `page="${page.id}"`,
    expand: "section",
  });

  const beforeContent = [];
  const betweenContent = [];
  const afterContent = [];

  for (const ps of pageSections) {
    const sectionDef = ps.expand?.section;
    const sectionData = {
      ...ps,
      items: [],
      parsedData: {},
      hasMore: false,
      totalPages: 1,
    };

    if (sectionDef) {
      sectionData.parsedData = parseCsvData(sectionDef.data_fields);

      if (sectionDef.type === "hero") {
        const items = await pb.collection("section_items_hero").getFullList({ sort: "created" });
        sectionData.items = items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, 'image'),
          alt: getAltText(item, ['title'])
        }));
      } else if (sectionDef.type === "products") {
        const result = await pb.collection("products").getList(currentPage, 6, { sort: "-created" });
        sectionData.items = result.items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, 'image'),
          alt: getAltText(item, ['name', 'title'])
        }));
        sectionData.totalPages = Math.ceil(result.totalItems / 6);
      } else if (sectionDef.type === "news") {
        const result = await pb.collection("news").getList(currentPage, 6, { sort: "-created" });
        sectionData.items = result.items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, 'image'),
          alt: getAltText(item, ['heading', 'title'])
        }));
        sectionData.totalPages = Math.ceil(result.totalItems / 6);
      } else if (sectionDef.type === "partners") {
        // ВАЖНО: теперь здесь 'image' вместо 'logo'
        const items = await pb.collection("section_items_partners").getFullList({ sort: "created" });
        sectionData.items = items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, 'image'),
          alt: getAltText(item, ['name', 'title'])
        }));
      } else if (sectionDef.type === "form") {
        sectionData.items = [];
      }
    }

    if (ps.position === "before_content") {
      beforeContent.push(sectionData);
    } else if (ps.position === "between_header_text") {
      betweenContent.push(sectionData);
    } else {
      afterContent.push(sectionData);
    }
  }

  return {
    page: {
      title: page.heading || page.meta_title || "Страница",
      html: page.content || "",
      slug: page.slug,
      image: getFullFileUrl(page, 'image'),
      alt: getAltText(page, ['heading', 'meta_title', 'title']),
      raw: page,
    },
    beforeContent,
    betweenContent,
    afterContent,
  };
}

function formatEntityResponse(entity, type) {
  return {
    page: {
      title: entity.heading || entity.name || entity.meta_title || "Страница",
      html: entity.content || entity.description || "",
      slug: entity.slug,
      image: getFullFileUrl(entity, 'image'),
      alt: getAltText(entity, ['heading', 'name', 'meta_title', 'title']),
      raw: entity,
      isEntity: true,
    },
    beforeContent: [],
    betweenContent: [],
    afterContent: [],
  };
}