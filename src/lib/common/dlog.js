// src/lib/common/dlog.js

const isDebug =
  (typeof process !== "undefined" && process.env.VITE_DEBUG === "true") ||
  import.meta.env.VITE_DEBUG === "true";

export function dlog(...args) {
  if (!isDebug) return;
  console.debug(...args);
}

if (typeof globalThis !== "undefined") {
  globalThis.dlog = dlog;
}
