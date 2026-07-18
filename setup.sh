#!/usr/bin/env bash
# setup.sh
# Генерация структуры проекта IFNEW. Запускать из корня проекта (рядом с package.json).

set -e

# ---------- Вспомогательные функции ----------
mk() { mkdir -p "$1"; }
w()  { cat > "$1" <<EOF
$2
EOF
}

# ---------- src/ ----------
mk src/routes/company
mk src/routes/products
mk src/routes/contacts
mk src/routes/api/contacts
mk src/routes/en/company
mk src/routes/en/products
mk src/routes/en/contacts

mk src/lib/components/Header
mk src/lib/components/Footer
mk src/lib/components/Hero
mk src/lib/components/Product
mk src/lib/components/Contact
mk src/lib/stores
mk src/lib/server/api
mk src/lib/frontend/api
mk src/lib/common

# ---------- src/app.html ----------
w src/app.html '<!doctype html>
<!-- src/app.html -->
<html lang="ru" data-theme="emerald">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" href="/favicon.svg" />
    <title>IFNEW</title>
    %sveltekit.head%
  </head>
  <body data-sveltekit-preload-data="hover">
    <div style="display: contents">%sveltekit.body%</div>
  </body>
</html>
'

# ---------- src/app.css ----------
w src/app.css '/* src/app.css */
@import "tailwindcss";
@plugin "daisyui" {
  themes: emerald --default, dim --prefersdark;
}

html, body {
  height: 100%;
}
body {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
'

# ---------- src/routes/+layout.svelte ----------
w src/routes/+layout.svelte '<!-- src/routes/+layout.svelte -->
<script>
  import Header from "$lib/components/Header/Header.svelte";
  import Footer from "$lib/components/Footer/Footer.svelte";
  import { theme } from "$lib/stores/theme.js";
  import { applyTheme } from "$lib/stores/theme.js";

  let { children } = $props();

  $effect(() => {
    applyTheme(theme.current);
  });
</script>

<div class="flex min-h-screen flex-col bg-base-100 text-base-content">
  <Header />
  <main class="flex-1">
    {@render children()}
  </main>
  <Footer />
</div>
'

# ---------- src/routes/+layout.server.js ----------
w src/routes/+layout.server.js '// src/routes/+layout.server.js
export const load = async ({ cookies }) => {
  const locale = cookies.get("locale") || "ru";
  return { locale };
};
'

# ---------- src/routes/+page.svelte (главная) ----------
w src/routes/+page.svelte '<!-- src/routes/+page.svelte -->
<script>
  import HeroCarousel from "$lib/components/Hero/HeroCarousel.svelte";

  let { data } = $props();
</script>

<section class="container mx-auto px-4 py-8">
  <HeroCarousel slides={data.hero} />
</section>

<section class="container mx-auto px-4 py-10">
  <article class="prose prose-lg max-w-3xl">
    <h2>{data.page.title}</h2>
    {@html data.page.html}
  </article>
</section>
'

# ---------- src/routes/+page.server.js ----------
w src/routes/+page.server.js '// src/routes/+page.server.js
import { getHero } from "$lib/server/api/hero.js";
import { getPage } from "$lib/server/api/pages.js";

export const load = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  return {
    hero: await getHero({ locale }),
    page: await getPage({ slug: "/", locale }),
  };
};
'

# ---------- /company/ ----------
w src/routes/company/+page.svelte '<!-- src/routes/company/+page.svelte -->
<script>
  let { data } = $props();
</script>

<section class="container mx-auto px-4 py-10">
  <article class="prose prose-lg max-w-3xl">
    <h1>{data.page.title}</h1>
    {@html data.page.html}
  </article>
</section>
'

w src/routes/company/+page.server.js '// src/routes/company/+page.server.js
import { getPage } from "$lib/server/api/pages.js";

export const load = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  return { page: await getPage({ slug: "/company/", locale }) };
};
'

# ---------- /products/ ----------
w src/routes/products/+page.svelte '<!-- src/routes/products/+page.svelte -->
<script>
  import ProductCard from "$lib/components/Product/ProductCard.svelte";
  import { goto } from "$app/navigation";
  import { page as pageStore } from "$app/stores";

  let { data } = $props();

  const currentPage = $derived(data.pagination.page);
  const totalPages = $derived(data.pagination.totalPages);

  function setPage(n) {
    goto(`/products/?page=${n}`, { replaceState: true, keepFocus: true });
  }
</script>

<section class="container mx-auto px-4 py-10">
  <h1 class="mb-8 text-3xl font-bold">{data.title}</h1>

  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
    {#each data.items as item (item.id)}
      <ProductCard product={item} />
    {/each}
  </div>

  {#if totalPages > 1}
    <div class="mt-10 flex justify-center">
      <div class="join">
        <button
          class="join-item btn"
          disabled={currentPage <= 1}
          onclick={() => setPage(currentPage - 1)}
        >«</button>
        {#each Array(totalPages) as _, i}
          <button
            class="join-item btn"
            class:btn-active={i + 1 === currentPage}
            onclick={() => setPage(i + 1)}
          >{i + 1}</button>
        {/each}
        <button
          class="join-item btn"
          disabled={currentPage >= totalPages}
          onclick={() => setPage(currentPage + 1)}
        >»</button>
      </div>
    </div>
  {/if}
</section>
'

w src/routes/products/+page.server.js '// src/routes/products/+page.server.js
import { getProducts } from "$lib/server/api/products.js";

export const load = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  const page = Math.max(1, Number(url.searchParams.get("page")) || 1);
  const result = await getProducts({ locale, page, perPage: 6 });
  return {
    title: "Товары",
    items: result.items,
    pagination: {
      page: result.page,
      perPage: result.perPage,
      total: result.total,
      totalPages: result.totalPages,
    },
  };
};
'

# ---------- /contacts/ ----------
w src/routes/contacts/+page.svelte '<!-- src/routes/contacts/+page.svelte -->
<script>
  import ContactInfo from "$lib/components/Contact/ContactInfo.svelte";
  import ContactForm from "$lib/components/Contact/ContactForm.svelte";
</script>

<section class="container mx-auto px-4 py-10">
  <h1 class="mb-8 text-3xl font-bold">Контакты</h1>

  <div class="grid grid-cols-1 gap-8 lg:grid-cols-2">
    <ContactInfo contacts={data.contacts} />
    <ContactForm />
  </div>
</section>
'

w src/routes/contacts/+page.server.js '// src/routes/contacts/+page.server.js
import { getContacts } from "$lib/server/api/pages.js";

export const load = async ({ url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  return { contacts: await getContacts({ locale }) };
};
'

# ---------- /api/contacts (POST) ----------
w src/routes/api/contacts/+server.js '// src/routes/api/contacts/+server.js
import { json } from "@sveltejs/kit";
import { submitContact } from "$lib/server/api/contacts.js";

export const POST = async ({ request, url }) => {
  const locale = url.searchParams.get("locale") || "ru";
  const body = await request.json();
  const result = await submitContact({ locale, payload: body });
  return json(result);
};
'

# ---------- /en/ (заглушка) ----------
w src/routes/en/+layout.svelte '<!-- src/routes/en/+layout.svelte -->
<script>
  let { children } = $props();
</script>

<div class="flex min-h-[60vh] items-center justify-center px-4">
  <div class="alert alert-warning max-w-md shadow-lg">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M4.93 19h14.14c1.34 0 2.17-1.45 1.5-2.62L13.5 4.38c-.67-1.17-2.33-1.17-3 0L3.43 16.38C2.76 17.55 3.59 19 4.93 19z" />
    </svg>
    <span class="text-lg font-semibold">Sorry, English version not available yet</span>
  </div>
</div>
'

w src/routes/en/+page.svelte '<!-- src/routes/en/+page.svelte -->
<div></div>
'
w src/routes/en/company/+page.svelte '<!-- src/routes/en/company/+page.svelte -->
<div></div>
'
w src/routes/en/products/+page.svelte '<!-- src/routes/en/products/+page.svelte -->
<div></div>
'
w src/routes/en/contacts/+page.svelte '<!-- src/routes/en/contacts/+page.svelte -->
<div></div>
'

# ============================================================
# LIB: stores
# ============================================================
w src/lib/stores/theme.js '// src/lib/stores/theme.js
import { browser } from "$app/environment";

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
'

w src/lib/stores/locale.js '// src/lib/stores/locale.js
import { browser } from "$app/environment";

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
'

# ============================================================
# LIB: common
# ============================================================
w src/lib/common/routes.js '// src/lib/common/routes.js
export const mainPages = [
  { slug: "/", title: "Главная" },
  { slug: "/company/", title: "О компании" },
  { slug: "/products/", title: "Товары" },
  { slug: "/contacts/", title: "Контакты" },
];

export function isActivePage(currentPath, pageSlug) {
  if (pageSlug === "/") return currentPath === "/";
  return currentPath.startsWith(pageSlug);
}
'

w src/lib/common/strings.js '// src/lib/common/strings.js
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
'

# ============================================================
# LIB: server/api (моки)
# ============================================================
w src/lib/server/api/pages.js '// src/lib/server/api/pages.js
const pages = {
  "/": {
    ru: {
      title: "IFNEW — промышленное оборудование",
      html: "<p>Компания <strong>IFNEW</strong> — ваш надёжный партнёр в сфере поставок промышленного оборудования. Мы работаем на рынке с 2013 года и за это время реализовали сотни проектов для предприятий по всей России.</p><p>Наша миссия — предоставлять клиентам современные технические решения, сочетающие высокое качество, энергоэффективность и разумную стоимость.</p>",
    },
  },
  "/company/": {
    ru: {
      title: "О компании",
      html: "<p>Компания <strong>IFNEW</strong> основана в 2013 году. За годы работы мы сформировали команду профессионалов и выстроили прямые отношения с ведущими производителями оборудования.</p><h3>Наши преимущества</h3><ul><li>Прямые поставки от производителей</li><li>Собственный склад и логистика</li><li>Техническая поддержка 24/7</li><li>Гибкие условия оплаты</li></ul>",
    },
  },
};

export async function getPage({ slug, locale = "ru" }) {
  const entry = pages[slug];
  if (!entry) return { title: "Страница", html: "<p>Содержимое не найдено.</p>" };
  return entry[locale] || entry.ru;
}

export async function getContacts({ locale = "ru" } = {}) {
  return {
    address: "Россия, 123456, г. Москва, ул. Промышленная, д. 10, оф. 205",
    phone: "+74951234567",
    email: "info@ifnew.ru",
    workHours: "Пн–Пт: 9:00–18:00",
  };
}
'

w src/lib/server/api/hero.js '// src/lib/server/api/hero.js
export async function getHero({ locale = "ru" } = {}) {
  return [
    {
      id: 1,
      title: "Современное оборудование",
      subtitle: "Поставки по всей России с 2013 года",
      cta: { label: "Подробнее", href: "/company/" },
      image: "https://picsum.photos/seed/ifnew1/1600/700",
    },
    {
      id: 2,
      title: "Прямые контракты",
      subtitle: "Работаем напрямую с производителями",
      cta: { label: "Каталог", href: "/products/" },
      image: "https://picsum.photos/seed/ifnew2/1600/700",
    },
    {
      id: 3,
      title: "Сервис 24/7",
      subtitle: "Техническая поддержка в любое время",
      cta: { label: "Связаться", href: "/contacts/" },
      image: "https://picsum.photos/seed/ifnew3/1600/700",
    },
  ];
}
'

w src/lib/server/api/products.js '// src/lib/server/api/products.js
const baseProducts = [
  {
    id: "pump-industrial-01",
    title: "Промышленный насос ИФ-100",
    description: "Высокопроизводительный центробежный насос для непрерывной эксплуатации.",
    price: 185000,
    image: "https://picsum.photos/seed/prod1/600/400",
  },
  {
    id: "compressor-air-02",
    title: "Компрессор воздушный КВ-50",
    description: "Маслосмазываемый поршневой компрессор для промышленных задач.",
    price: 240000,
    image: "https://picsum.photos/seed/prod2/600/400",
  },
  {
    id: "filter-hydro-03",
    title: "Гидравлический фильтр ГФ-20",
    description: "Фильтр тонкой очистки для гидравлических систем.",
    price: 42000,
    image: "https://picsum.photos/seed/prod3/600/400",
  },
];

function buildCatalog() {
  const result = [];
  for (let i = 0; i < 10; i++) {
    const base = baseProducts[i % baseProducts.length];
    const n = i + 1;
    result.push({
      ...base,
      id: `${base.id}-${n}`,
      title: `${base.title} (№${n})`,
    });
  }
  return result;
}

const catalog = buildCatalog();

export async function getProducts({ locale = "ru", page = 1, perPage = 6 } = {}) {
  const safePage = Math.max(1, Number(page) || 1);
  const safePerPage = Math.max(1, Math.min(50, Number(perPage) || 6));
  const total = catalog.length;
  const totalPages = Math.max(1, Math.ceil(total / safePerPage));
  const currentPage = Math.min(safePage, totalPages);
  const start = (currentPage - 1) * safePerPage;
  const items = catalog.slice(start, start + safePerPage);
  return { items, page: currentPage, perPage: safePerPage, total, totalPages };
}
'

w src/lib/server/api/contacts.js '// src/lib/server/api/contacts.js
export async function submitContact({ locale = "ru", payload } = {}) {
  await new Promise((r) => setTimeout(r, 300));
  return {
    ok: true,
    message: "Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.",
    receivedAt: new Date().toISOString(),
    locale,
  };
}
'

# ============================================================
# LIB: frontend/api
# ============================================================
w src/lib/frontend/api/pages.js '// src/lib/frontend/api/pages.js
import { buildUrl } from "./_http.js";

export async function fetchPage({ slug, locale = "ru" } = {}) {
  const res = await fetch(buildUrl(`/api/pages`, { slug, locale }));
  if (!res.ok) throw new Error("Failed to load page");
  return res.json();
}
'

w src/lib/frontend/api/_http.js '// src/lib/frontend/api/_http.js
import { locale } from "$lib/stores/locale.js";

export function buildUrl(path, params = {}) {
  const url = new URL(path, window.location.origin);
  url.searchParams.set("locale", params.locale || locale.current);
  for (const [k, v] of Object.entries(params)) {
    if (k === "locale") continue;
    if (v !== undefined && v !== null) url.searchParams.set(k, String(v));
  }
  return url.toString();
}

export async function postJson(path, body, { locale: loc } = {}) {
  const url = buildUrl(path, { locale: loc });
  const res = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error("Request failed");
  return res.json();
}
'

w src/lib/frontend/api/products.js '// src/lib/frontend/api/products.js
import { buildUrl } from "./_http.js";

export async function fetchProducts({ locale = "ru", page = 1, perPage = 6 } = {}) {
  const res = await fetch(buildUrl(`/api/products`, { locale, page, perPage }));
  if (!res.ok) throw new Error("Failed to load products");
  return res.json();
}
'

w src/lib/frontend/api/hero.js '// src/lib/frontend/api/hero.js
import { buildUrl } from "./_http.js";

export async function fetchHero({ locale = "ru" } = {}) {
  const res = await fetch(buildUrl(`/api/hero`, { locale }));
  if (!res.ok) throw new Error("Failed to load hero");
  return res.json();
}
'

w src/lib/frontend/api/contacts.js '// src/lib/frontend/api/contacts.js
import { postJson } from "./_http.js";

export async function sendContactForm(payload, { locale = "ru" } = {}) {
  return postJson(`/api/contacts`, payload, { locale });
}
'

# ============================================================
# LIB: components — Header
# ============================================================
w src/lib/components/Header/Header.svelte '<!-- src/lib/components/Header/Header.svelte -->
<script>
  import Logo from "./Logo.svelte";
  import NavMenu from "./NavMenu.svelte";
  import ThemeSwitch from "./ThemeSwitch.svelte";
  import LangSwitch from "./LangSwitch.svelte";
</script>

<header class="sticky top-0 z-40 border-b border-base-200 bg-base-100/90 backdrop-blur">
  <div class="container mx-auto flex h-16 items-center justify-between gap-4 px-4">
    <Logo />
    <NavMenu />
    <div class="flex items-center gap-2">
      <LangSwitch />
      <ThemeSwitch />
    </div>
  </div>
</header>
'

w src/lib/components/Header/Logo.svelte '<!-- src/lib/components/Header/Logo.svelte -->
<script>
  const name = "IFNEW";
  const href = "/";
</script>

<a {href} class="flex items-center gap-2 text-xl font-bold tracking-tight">
  <span class="grid h-9 w-9 place-items-center rounded-lg bg-primary text-primary-content">
    <span class="text-lg">IF</span>
  </span>
  <span>{name}</span>
</a>
'

w src/lib/components/Header/NavMenu.svelte '<!-- src/lib/components/Header/NavMenu.svelte -->
<script>
  import { page } from "$app/stores";
  import { mainPages, isActivePage } from "$lib/common/routes.js";

  const currentPath = $derived($page.url.pathname);
</script>

<nav class="hidden md:block">
  <ul class="menu menu-horizontal gap-1 px-0">
    {#each mainPages as p}
      <li>
        <a
          href={p.slug}
          class:active={isActivePage(currentPath, p.slug)}
          class:font-semibold={isActivePage(currentPath, p.slug)}
        >{p.title}</a>
      </li>
    {/each}
  </ul>
</nav>

<div class="dropdown dropdown-end md:hidden">
  <button tabindex="0" class="btn btn-ghost btn-square" aria-label="Меню">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
    </svg>
  </button>
  <ul tabindex="0" class="menu dropdown-content mt-3 w-56 rounded-box bg-base-100 p-2 shadow-lg">
    {#each mainPages as p}
      <li>
        <a href={p.slug} class:active={isActivePage(currentPath, p.slug)}>{p.title}</a>
      </li>
    {/each}
  </ul>
</div>
'

w src/lib/components/Header/ThemeSwitch.svelte '<!-- src/lib/components/Header/ThemeSwitch.svelte -->
<script>
  import { theme, toggleTheme } from "$lib/stores/theme.js";

  const isDark = $derived(theme.current === "dim");
</script>

<button
  type="button"
  class="btn btn-ghost btn-circle"
  aria-label="Переключить тему"
  onclick={toggleTheme}
>
  {#if isDark}
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m8.485-8.485h-1M5.515 11.515h-1M18.364 5.636l-.707.707M6.343 17.657l-.707.707M18.364 18.364l-.707-.707M6.343 6.343l-.707-.707M12 8a4 4 0 100 8 4 4 0 000-8z" />
    </svg>
  {:else}
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
    </svg>
  {/if}
</button>
'

w src/lib/components/Header/LangSwitch.svelte '<!-- src/lib/components/Header/LangSwitch.svelte -->
<script>
  const hidden = true;
</script>

{#if !hidden}
  <div class="join">
    <button class="btn btn-sm join-item">RU</button>
    <button class="btn btn-sm join-item">EN</button>
  </div>
{/if}
'

# ============================================================
# LIB: components — Footer
# ============================================================
w src/lib/components/Footer/Footer.svelte '<!-- src/lib/components/Footer/Footer.svelte -->
<script>
  import NavFooter from "./NavFooter.svelte";
  import ContactsFooter from "./ContactsFooter.svelte";
  import Copyright from "./Copyright.svelte";
</script>

<footer class="mt-auto border-t border-base-200 bg-base-200 text-base-content">
  <div class="container mx-auto grid grid-cols-1 gap-8 px-4 py-10 md:grid-cols-3">
    <NavFooter />
    <NavFooter variant="second" />
    <ContactsFooter />
  </div>
  <Copyright />
</footer>
'

w src/lib/components/Footer/NavFooter.svelte '<!-- src/lib/components/Footer/NavFooter.svelte -->
<script>
  import { mainPages } from "$lib/common/routes.js";

  let { variant = "first" } = $props();

  const blocks = {
    first: {
      title: "Навигация",
      items: mainPages,
    },
    second: {
      title: "Услуги",
      items: [
        { slug: "/products/", title: "Каталог оборудования" },
        { slug: "/products/", title: "Пусконаладка" },
        { slug: "/products/", title: "Сервисное обслуживание" },
        { slug: "/company/", title: "О компании" },
      ],
    },
  };

  const block = blocks[variant] || blocks.first;
</script>

<div>
  <h3 class="mb-3 text-sm font-semibold uppercase tracking-wider opacity-70">{block.title}</h3>
  <ul class="flex flex-col gap-2">
    {#each block.items as item}
      <li>
        <a href={item.slug} class="link link-hover">{item.title}</a>
      </li>
    {/each}
  </ul>
</div>
'

w src/lib/components/Footer/ContactsFooter.svelte '<!-- src/lib/components/Footer/ContactsFooter.svelte -->
<script>
  import { formatPhone } from "$lib/common/strings.js";

  const address = "г. Москва, ул. Промышленная, 10";
  const phone = "+74951234567";
  const email = "info@ifnew.ru";
</script>

<div>
  <h3 class="mb-3 text-sm font-semibold uppercase tracking-wider opacity-70">Контакты</h3>
  <address class="flex flex-col gap-2 not-italic">
    <span>{address}</span>
    <a class="link link-hover" href={`tel:${phone}`}>{formatPhone(phone)}</a>
    <a class="link link-hover" href={`mailto:${email}`}>{email}</a>
  </address>
</div>
'

w src/lib/components/Footer/Copyright.svelte '<!-- src/lib/components/Footer/Copyright.svelte -->
<script>
  import { currentYear } from "$lib/common/strings.js";

  const startYear = 2013;
  const endYear = currentYear();
  const label = startYear === endYear ? `${startYear}` : `${startYear}–${endYear}`;
</script>

<div class="border-t border-base-300 py-4 text-center text-sm opacity-70">
  © {label} IFNEW. Все права защищены.
</div>
'

# ============================================================
# LIB: components — Hero
# ============================================================
w src/lib/components/Hero/HeroCarousel.svelte '<!-- src/lib/components/Hero/HeroCarousel.svelte -->
<script>
  import HeroSlide from "./HeroSlide.svelte";

  let { slides = [] } = $props();
  let index = $state(0);
  let timer;

  const count = $derived(slides.length);

  function next() {
    if (count === 0) return;
    index = (index + 1) % count;
  }
  function prev() {
    if (count === 0) return;
    index = (index - 1 + count) % count;
  }
  function go(i) {
    index = i;
  }

  $effect(() => {
    if (count <= 1) return;
    timer = setInterval(next, 6000);
    return () => clearInterval(timer);
  });
</script>

{#if count > 0}
  <section class="relative overflow-hidden rounded-box">
    <div class="relative aspect-[16/7] w-full sm:aspect-[16/6] lg:aspect-[16/5]">
      {#each slides as slide, i (slide.id)}
        <div
          class="absolute inset-0 transition-opacity duration-700"
          class:opacity-100={i === index}
          class:opacity-0={i !== index}
          aria-hidden={i !== index}
        >
          <HeroSlide {slide} />
        </div>
      {/each}
    </div>

    {#if count > 1}
      <div class="absolute inset-x-0 bottom-4 flex items-center justify-center gap-2">
        {#each slides as _, i}
          <button
            type="button"
            class="btn btn-xs btn-circle"
            class:btn-primary={i === index}
            class:btn-ghost={i !== index}
            aria-label="Слайд {i + 1}"
            onclick={() => go(i)}
          ></button>
        {/each}
      </div>

      <button
        type="button"
        class="btn btn-circle btn-sm absolute left-2 top-1/2 -translate-y-1/2"
        aria-label="Предыдущий слайд"
        onclick={prev}
      >‹</button>
      <button
        type="button"
        class="btn btn-circle btn-sm absolute right-2 top-1/2 -translate-y-1/2"
        aria-label="Следующий слайд"
        onclick={next}
      >›</button>
    {/if}
  </section>
{/if}
'

w src/lib/components/Hero/HeroSlide.svelte '<!-- src/lib/components/Hero/HeroSlide.svelte -->
<script>
  let { slide } = $props();
</script>

<div class="relative h-full w-full">
  <img
    src={slide.image}
    alt={slide.title}
    class="absolute inset-0 h-full w-full object-cover"
    loading="lazy"
  />
  <div class="absolute inset-0 bg-gradient-to-t from-base-100/90 via-base-100/40 to-base-100/10"></div>
  <div class="relative flex h-full flex-col justify-end p-6 sm:p-10">
    <h2 class="text-2xl font-bold sm:text-4xl lg:text-5xl">{slide.title}</h2>
    <p class="mt-2 max-w-xl text-base opacity-80 sm:text-lg">{slide.subtitle}</p>
    {#if slide.cta}
      <div class="mt-4">
        <a href={slide.cta.href} class="btn btn-primary">{slide.cta.label}</a>
      </div>
    {/if}
  </div>
</div>
'

# ============================================================
# LIB: components — Product
# ============================================================
w src/lib/components/Product/ProductCard.svelte '<!-- src/lib/components/Product/ProductCard.svelte -->
<script>
  let { product } = $props();

  const formattedPrice = $derived(
    new Intl.NumberFormat("ru-RU", { style: "currency", currency: "RUB", maximumFractionDigits: 0 }).format(product.price)
  );
</script>

<article class="card bg-base-100 shadow-sm transition hover:shadow-md">
  <figure class="aspect-[3/2] overflow-hidden">
    <img src={product.image} alt={product.title} class="h-full w-full object-cover" loading="lazy" />
  </figure>
  <div class="card-body gap-2 p-4">
    <h3 class="card-title text-base">{product.title}</h3>
    <p class="line-clamp-2 text-sm opacity-70">{product.description}</p>
    <div class="mt-2 flex items-center justify-between">
      <span class="text-lg font-semibold">{formattedPrice}</span>
      <a href={`/products/${product.id}/`} class="btn btn-sm btn-primary">Подробнее</a>
    </div>
  </div>
</article>
'

# ============================================================
# LIB: components — Contact
# ============================================================
w src/lib/components/Contact/ContactInfo.svelte '<!-- src/lib/components/Contact/ContactInfo.svelte -->
<script>
  import { formatPhone } from "$lib/common/strings.js";

  let { contacts } = $props();
</script>

<div class="rounded-box border border-base-200 bg-base-100 p-6">
  <h2 class="mb-4 text-xl font-semibold">Как с нами связаться</h2>
  <dl class="flex flex-col gap-4">
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Адрес</dt>
      <dd class="mt-1">{contacts.address}</dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Телефон</dt>
      <dd class="mt-1">
        <a class="link link-hover" href={`tel:${contacts.phone}`}>{formatPhone(contacts.phone)}</a>
      </dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Email</dt>
      <dd class="mt-1">
        <a class="link link-hover" href={`mailto:${contacts.email}`}>{contacts.email}</a>
      </dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Режим работы</dt>
      <dd class="mt-1">{contacts.workHours}</dd>
    </div>
  </dl>
</div>
'

w src/lib/components/Contact/ContactForm.svelte '<!-- src/lib/components/Contact/ContactForm.svelte -->
<script>
  import { sendContactForm } from "$lib/frontend/api/contacts.js";

  let name = $state("");
  let phone = $state("");
  let message = $state("");
  let status = $state("idle");
  let responseMessage = $state("");

  async function handleSubmit(e) {
    e.preventDefault();
    status = "submitting";
    responseMessage = "";
    try {
      const res = await sendContactForm({ name, phone, message });
      responseMessage = res.message;
      status = "success";
      name = "";
      phone = "";
      message = "";
    } catch (err) {
      status = "error";
      responseMessage = "Не удалось отправить заявку. Попробуйте позже.";
    }
  }
</script>

<form class="rounded-box border border-base-200 bg-base-100 p-6" onsubmit={handleSubmit}>
  <h2 class="mb-4 text-xl font-semibold">Оставить заявку</h2>

  <label class="form-control mb-3">
    <span class="mb-1 text-sm">Ваше имя</span>
    <input type="text" class="input input-bordered" bind:value={name} required />
  </label>

  <label class="form-control mb-3">
    <span class="mb-1 text-sm">Телефон</span>
    <input type="tel" class="input input-bordered" bind:value={phone} required />
  </label>

  <label class="form-control mb-4">
    <span class="mb-1 text-sm">Сообщение</span>
    <textarea class="textarea textarea-bordered" rows="4" bind:value={message}></textarea>
  </label>

  <button type="submit" class="btn btn-primary w-full" disabled={status === "submitting"}>
    {#if status === "submitting"}
      <span class="loading loading-spinner"></span>
      Отправка...
    {:else}
      Отправить
    {/if}
  </button>

  {#if responseMessage}
    <div class="mt-4">
      <div class={status === "success" ? "alert alert-success" : "alert alert-error"}>
        <span>{responseMessage}</span>
      </div>
    </div>
  {/if}
</form>
'

# ---------- Готово ----------
echo "✅ Структура IFNEW сгенерирована."
echo "   Далее: pnpm prepare && pnpm dev"