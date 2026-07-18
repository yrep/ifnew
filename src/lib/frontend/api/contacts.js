// src/lib/frontend/api/contacts.js
import { postJson } from "./_http.js";

export async function sendContactForm(payload, { locale = "ru" } = {}) {
  return postJson(`/api/contacts`, payload, { locale });
}

