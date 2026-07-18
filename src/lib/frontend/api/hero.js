// src/lib/frontend/api/hero.js
import { buildUrl } from "./_http.js";

export async function fetchHero({ locale = "ru" } = {}) {
  const res = await fetch(buildUrl(`/api/hero`, { locale }));
  if (!res.ok) throw new Error("Failed to load hero");
  return res.json();
}

