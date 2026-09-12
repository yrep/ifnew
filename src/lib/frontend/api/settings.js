import { fetchJson } from './_http.js';

export function fetchSetting(key, { locale } = {}) {
  return fetchJson('/api/settings', { key, locale });
}

export function fetchSettings({ group, locale } = {}) {
  return fetchJson('/api/settings', { group, locale });
}