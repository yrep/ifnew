// src/lib/frontend/api/_http.js
import { locale } from "$lib/stores/locale.svelte.js";
import { dlog } from "$lib/common/dlog.js";

export function buildUrl(path, params = {}) {
  const url = new URL(
    path,
    typeof window !== "undefined"
      ? window.location.origin
      : "http://localhost:5173",
  );
  url.searchParams.set("locale", params.locale || locale.current);

  for (const [k, v] of Object.entries(params)) {
    if (k === "locale") continue;
    if (v !== undefined && v !== null) url.searchParams.set(k, String(v));
  }

  return url.pathname + url.search;
}

export async function fetchJson(path, params = {}) {
  const url = buildUrl(path, params);
  dlog("API-REQ", `🚀 GET ${path}`, { params });

  try {
    const res = await fetch(url);
    const data = await res.json();
    dlog("API-RES", `${res.ok ? "✅" : "❌"} ${res.status} ${path}`, { data });

    if (!res.ok) throw new Error(data.error || `HTTP ${res.status}`);
    return data;
  } catch (err) {
    dlog("API-ERR", `❌ fetchJson ${path}`, { error: err.message });
    throw err;
  }
}

export async function postJson(path, body, params = {}) {
  const url = buildUrl(path, params);
  dlog("API-REQ", `🚀 POST ${path}`, { body, params });

  try {
    const res = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const data = await res.json();
    dlog("API-RES", `${res.ok ? "✅" : "❌"} ${res.status} ${path}`, { data });

    if (!res.ok) throw new Error(data.error || `HTTP ${res.status}`);
    return data;
  } catch (err) {
    dlog("API-ERR", `❌ postJson ${path}`, { error: err.message });
    throw err;
  }
}
