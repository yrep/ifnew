// src/lib/common/strings.js
export function slugify(value) {
  return String(value || "")
    .trim()
    .toLowerCase()
    .replace(/[\s_]+/g, "-")
    .replace(/[^\p{L}\p{N}-]/gu, "")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");
}

export function truncate(value, length = 120) {
  const s = String(value || "");
  if (s.length <= length) return s;
  return s.slice(0, length).trimEnd() + "…";
}

export function formatPhone(raw) {
  const digits = String(raw || "").replace(/\D/g, "");
  if (digits.length !== 11) return raw;
  return `+${digits[0]} (${digits.slice(1, 4)}) ${digits.slice(4, 7)}-${digits.slice(7, 9)}-${digits.slice(9)}`;
}

export function currentYear() {
  return new Date().getFullYear();
}

