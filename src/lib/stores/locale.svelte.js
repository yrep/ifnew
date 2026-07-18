// src/lib/stores/locale.svelte.js
import { browser } from "$app/env";

const STORAGE_KEY = "ifnew:locale";
const LOCALES = ["ru", "en"];
const DEFAULT_LOCALE = "ru";

function readInitial() {
  if (!browser) return DEFAULT_LOCALE;
  const saved = localStorage.getItem(STORAGE_KEY);
  return LOCALES.includes(saved) ? saved : DEFAULT_LOCALE;
}

export const locale = $state({ current: readInitial() });

export function setLocale(value) {
  if (!LOCALES.includes(value)) return;
  locale.current = value;
  if (browser) localStorage.setItem(STORAGE_KEY, value);
}
