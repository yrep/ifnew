// src/routes/api/contacts/+server.js
import { json } from "@sveltejs/kit";
import { submitContact } from "$lib/server/api/contacts.js";

export const POST = async ({ request, url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  const body = await request.json();
  const result = await submitContact({ locale, payload: body });
  return json(result);
};

