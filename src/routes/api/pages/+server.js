// src/routes/api/pages/+server.js
import { json } from "@sveltejs/kit";
import { getPage } from "$lib/server/api/pages.js";

export const GET = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  const slug = url.searchParams.get("slug") || "/";

  try {
    const data = await getPage({ slug, locale });
    return json(data);
  } catch (err) {
    return json({ error: err.message }, { status: 500 });
  }
};
