// src/lib/common/productsGridParser.js
const MAX_PER_ROW = 5;

export function parseProductsGridConfig(raw) {
  if (!raw || typeof raw !== 'string') return null;

  const result = { first: null, inner: null, last: null };

  for (const line of raw.split(/\r?\n/)) {
    const trimmed = line.trim();
    const idx = trimmed.indexOf(':');
    if (idx < 0) continue;

    const key = trimmed.slice(0, idx).trim().toLowerCase();
    if (!(key in result)) continue;

    const value = trimmed.slice(idx + 1).trim();
    if (!value) {
      result[key] = null;
      continue;
    }

    const n = parseInt(value, 10);
    if (Number.isFinite(n) && n > 0) {
      result[key] = Math.min(n, MAX_PER_ROW);
    }
  }

  if (result.first == null && result.inner == null) return null;
  if (result.first == null) result.first = result.inner;
  if (result.inner == null) result.inner = result.first;

  return result;
}

export function computeProductsGridRows(total, config) {
  if (!config || !Number.isFinite(total) || total <= 0) return [];

  const rows = [];
  let remaining = total;

  const first = Math.min(config.first, remaining);
  if (first > 0) {
    rows.push(first);
    remaining -= first;
  }

  while (remaining > 0) {
    const count = Math.min(config.inner, remaining);
    rows.push(count);
    remaining -= count;
  }

  return rows;
}