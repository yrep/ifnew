// src/lib/stores/theme.svelte.js
import { browser } from "$app/env";

const STORAGE_KEY = "ifnew:theme";
const THEMES = ["emerald", "dim"];
const DEFAULT_THEME = "emerald";

function readInitial() {
  if (!browser) return DEFAULT_THEME;
  const saved = localStorage.getItem(STORAGE_KEY);
  return THEMES.includes(saved) ? saved : DEFAULT_THEME;
}

export const theme = $state({ current: readInitial() });

export function applyTheme(value) {
  if (!browser) return;
  document.documentElement.setAttribute("data-theme", value);
}

export function setTheme(value) {
  if (!THEMES.includes(value)) return;
  theme.current = value;
  if (browser) localStorage.setItem(STORAGE_KEY, value);
  applyTheme(value);
}

export function toggleTheme() {
  setTheme(theme.current === "emerald" ? "dim" : "emerald");
}
