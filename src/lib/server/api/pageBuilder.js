import { pb } from "$lib/server/pocketbase.js";
import { dlog } from "$lib/common/dlog.js";
import { parseCsvData } from "$lib/common/csvParser.js";
import { config } from "$lib/common/config.js";
import { getFullFileUrl, getAltText } from "$lib/common/fileUtils.js";

export async function buildPage(filter, cleanSlug, currentPage = 1, categorySlug = null) {
  dlog("PB", "Search", { filter, cleanSlug, currentPage, categorySlug });

  try {
    const parts = cleanSlug
      ? cleanSlug.split("/").filter((p) => p.length > 0)
      : [];
    const level = parts.length;

    if (level <= 1) {
      dlog("PB", "Level 1: CMS only");
      const publishedFilter = `(${filter}) && status="published"`;
      const page = await pb.collection("pages").getFirstListItem(publishedFilter);

      dlog("PB", "Found", { heading: page.heading, slug: page.slug });
      return await formatPageResponse(page, currentPage, categorySlug);
    }

    dlog("PB", "Level 2: entities");
    const lastPart = parts[parts.length - 1];
    let collectionName = null;

    if (cleanSlug.includes("news")) collectionName = "news";
    else if (cleanSlug.includes("produkciya")) collectionName = "products";
    else if (cleanSlug.includes("stati")) collectionName = "articles";

    if (!collectionName) {
      throw new Error("Unknown entity section");
    }

    const expandFields = collectionName === "products" ? "category" : "";
    const entity = await pb.collection(collectionName).getFirstListItem(`slug~"${lastPart}"`, {
      expand: expandFields
    });
    
    dlog("PB", "Entity found", { heading: entity.heading, slug: entity.slug });

    return formatEntityResponse(entity, collectionName);
  } catch (err) {
    dlog("PB-ERR", "Error", { message: err.message });
    throw new Error("Failed to load page: " + err.message);
  }
}

async function formatPageResponse(page, currentPage, categorySlug = null) {
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
      viewMode: "default",
    };

    if (sectionDef) {
      sectionData.parsedData = parseCsvData(sectionDef.data_fields);

      if (sectionDef.type === "hero") {
        const items = await pb.collection("section_items_hero").getFullList({ sort: "created" });
        dlog("Items from db", items);
        sectionData.items = items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, "image"),
          alt: getAltText(item, ["title"])
        }));
      } else if (sectionDef.type === "products") {
        if (categorySlug) {
          try {
            const catRecord = await pb.collection("product_categories").getFirstListItem(`slug="${categorySlug}"`);
            const result = await pb.collection("products").getList(currentPage, 6, { 
              filter: `status="published" && category="${catRecord.id}"`,
              sort: "-created" 
            });
            sectionData.items = result.items.map(item => ({ 
              ...item, 
              image: getFullFileUrl(item, "image"),
              alt: getAltText(item, ["name", "title"])
            }));
            sectionData.totalPages = Math.ceil(result.totalItems / 6);
            sectionData.viewMode = "grid";
          } catch (e) {
            sectionData.items = [];
            sectionData.totalPages = 0;
            sectionData.viewMode = "grid";
          }
        } else {
          const items = await pb.collection("products").getFullList({ 
            filter: `status="published"`,
            expand: "category",
            sort: "-created"
          });
          sectionData.items = items.map(item => ({ 
            ...item, 
            category: item.expand?.category || null,
            image: getFullFileUrl(item, "image"),
            alt: getAltText(item, ["name", "title"])
          }));
          sectionData.viewMode = "list";
        }
      } else if (sectionDef.type === "news") {
        const result = await pb.collection("news").getList(currentPage, 6, { 
          filter: `status="published"`,
          sort: "-display_date" 
        });
        sectionData.items = result.items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, "image"),
          alt: getAltText(item, ["heading", "title"])
        }));
        sectionData.totalPages = Math.ceil(result.totalItems / 6);
      } else if (sectionDef.type === "partners") {
        const items = await pb.collection("section_items_partners").getFullList({ 
          sort: "created" 
        });
        sectionData.items = items.map(item => ({ 
          ...item, 
          image: getFullFileUrl(item, "image"),
          alt: getAltText(item, ["name", "title"])
        }));
      } else if (sectionDef.type === "form") {
        sectionData.items = [];
      }
    }
    
    dlog("Section data to pass", sectionData);

    if (ps.position === "before_content") {
      beforeContent.push(sectionData);
    } else if (ps.position === "between_header_text") {
      betweenContent.push(sectionData);
    } else {
      afterContent.push(sectionData);
    }
  }

  dlog("Page image db", page.image);
  dlog("Page image url", getFullFileUrl(page, "image"));

  return {
    page: {
      title: page.heading || page.meta_title || "Page",
      html: page.content || "",
      slug: page.slug,
      image: getFullFileUrl(page, "image"),
      alt: getAltText(page, ["heading", "meta_title", "title"]),
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
      title: entity.heading || entity.name || entity.meta_title || "Page",
      html: entity.content || entity.description || "",
      slug: entity.slug,
      image: getFullFileUrl(entity, "image"),
      alt: getAltText(entity, ["heading", "name", "meta_title", "title"]),
      raw: entity,
      isEntity: true,
    },
    beforeContent: [],
    betweenContent: [],
    afterContent: [],
  };
}