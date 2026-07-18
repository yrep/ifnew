// src/routes/api/products/+server.js
import { json } from "@sveltejs/kit";
import { getProducts } from "$lib/server/api/products.js";

export const GET = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  const page = Number(url.searchParams.get("page")) || 1;

  try {
    const data = await getProducts({ locale, page });
    return json(data);
  } catch (err) {
    return json({ error: err.message }, { status: 500 });
  }
};
