#!/bin/bash

# ВНИМАНИЕ: Скрипт выполняется в корне проекта ifnew, после установки зависимостей.

# Очистка стандартных файлов SvelteKit
rm -f src/app.css src/routes/+page.svelte

# Создание директорий
mkdir -p src/lib/common
mkdir -p src/lib/frontend/api
mkdir -p src/lib/server/api
mkdir -p src/lib/stores
mkdir -p src/lib/components/Header
mkdir -p src/lib/components/Footer
mkdir -p src/lib/components/Home
mkdir -p src/lib/components/Products
mkdir -p src/lib/components/Contacts
mkdir -p src/routes/company
mkdir -p src/routes/products
mkdir -p src/routes/contacts
mkdir -p src/routes/en/[slug]
mkdir -p src/routes/api/pages/[slug]
mkdir -p src/routes/api/products
mkdir -p src/routes/api/contacts

# ================= FILES =================

cat << 'EOF' > src/app.css
/* src/app.css */
@import "tailwindcss";
@plugin "daisyui";
EOF

cat << 'EOF' > src/lib/common/utils.js
/* ../../lib/common/utils.js */
/** @param {string} str */
export function capitalizeFirstLetter(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}
EOF

cat << 'EOF' > src/lib/server/api/pages.js
/* ../../lib/server/api/pages.js */
const mockPages = {
  '/': {
    title: 'Главная',
    hero: [
      { id: 1, title: 'Решения для бизнеса', image: 'https://placehold.co/1200x400/1e293b/ffffff?text=Hero+1' },
      { id: 2, title: 'Инновационные технологии', image: 'https://placehold.co/1200x400/115e59/ffffff?text=Hero+2' },
      { id: 3, title: 'Надежность и качество', image: 'https://placehold.co/1200x400/365314/ffffff?text=Hero+3' }
    ],
    text: 'Мы предоставляем передовые решения для автоматизации и оптимизации ваших бизнес-процессов. Более 10 лет на рынке.'
  },
  '/company/': {
    title: 'О компании',
    text: 'Наша компания была основана в 2013 году. Мы специализируемся на разработке и внедрении комплексных IT-решений. Наша команда состоит из высококвалифицированных специалистов, готовых решить любую задачу.'
  }
};

/** @param {string} slug @param {string} locale */
export function getPageData(slug, locale) {
  return mockPages[slug] || null;
}
EOF

cat << 'EOF' > src/lib/server/api/products.js
/* ../../lib/server/api/products.js */
const baseProducts = [
  { id: 1, slug: 'product-1', title: 'Базовый пакет', description: 'Идеально для малого бизнеса.', price: '10 000 руб.' },
  { id: 2, slug: 'product-2', title: 'Стандартный пакет', description: 'Оптимальное решение для растущих компаний.', price: '25 000 руб.' },
  { id: 3, slug: 'product-3', title: 'Премиум пакет', description: 'Все включено для крупного enterprise.', price: '50 000 руб.' }
];

function generateProducts() {
  let res = [];
  for (let i = 0; i < 10; i++) {
    res.push({ ...baseProducts[i % 3], id: i + 1, title: `${baseProducts[i % 3].title} (Вариант ${i + 1})` });
  }
  return res;
}

/** @param {string} locale @param {number} page @param {number} perPage */
export function getProducts(locale, page = 1, perPage = 6) {
  const all = generateProducts();
  const start = (page - 1) * perPage;
  const items = all.slice(start, start + perPage);
  return { items, total: all.length, page, perPage, totalPages: Math.ceil(all.length / perPage) };
}
EOF

cat << 'EOF' > src/lib/server/api/contacts.js
/* ../../lib/server/api/contacts.js */
/** @param {Object} body @param {string} locale */
export function submitContactForm(body, locale) {
  return { success: true, message: 'Сообщение успешно отправлено (мок)' };
}
EOF

cat << 'EOF' > src/lib/frontend/api/client.js
/* ../../lib/frontend/api/client.js */
import { getLocale } from '../../stores/index.svelte.js';

/** @param {string} url @param {RequestInit} [options] */
export async function apiClient(url, options = {}) {
  const locale = getLocale();
  const separator = url.includes('?') ? '&' : '?';
  const fullUrl = `${url}${separator}locale=${locale}`;
  
  const response = await fetch(fullUrl, {
    headers: { 'Content-Type': 'application/json', ...options.headers },
    ...options
  });
  return response.json();
}
EOF

cat << 'EOF' > src/lib/stores/index.svelte.js
/* ../../lib/stores/index.svelte.js */
let theme = $state('emerald');
let locale = $state('ru');

export function getTheme() { return theme; }
export function setTheme(t) { theme = t; }
export function toggleTheme() { theme = theme === 'emerald' ? 'dim' : 'emerald'; }
export function getLocale() { return locale; }
EOF

cat << 'EOF' > src/routes/api/pages/[slug]/+server.js
/* ../../routes/api/pages/[slug]/+server.js */
import { json } from '@sveltejs/kit';
import { getPageData } from '$lib/server/api/pages.js';

export async function GET({ params }) {
  const data = getPageData('/' + params.slug);
  if (!data) return json({ error: 'Not found' }, { status: 404 });
  return json(data);
}
EOF

cat << 'EOF' > src/routes/api/products/+server.js
/* ../../routes/api/products/+server.js */
import { json } from '@sveltejs/kit';
import { getProducts } from '$lib/server/api/products.js';

export async function GET({ url }) {
  const page = Number(url.searchParams.get('page') || '1');
  const locale = url.searchParams.get('locale') || 'ru';
  return json(getProducts(locale, page));
}
EOF

cat << 'EOF' > src/routes/api/contacts/+server.js
/* ../../routes/api/contacts/+server.js */
import { json } from '@sveltejs/kit';
import { submitContactForm } from '$lib/server/api/contacts.js';

export async function POST({ request }) {
  const body = await request.json();
  const locale = new URL(request.url).searchParams.get('locale') || 'ru';
  return json(submitContactForm(body, locale));
}
EOF

cat << 'EOF' > src/routes/+page.server.js
/* ../+page.server.js */
import { apiClient } from '$lib/frontend/api/client.js';

export async function load() {
  return await apiClient('/api/pages/');
}
EOF

cat << 'EOF' > src/routes/company/+page.server.js
/* ../company/+page.server.js */
import { apiClient } from '$lib/frontend/api/client.js';

export async function load() {
  return await apiClient('/api/pages/company/');
}
EOF

cat << 'EOF' > src/routes/products/+page.server.js
/* ../products/+page.server.js */
import { apiClient } from '$lib/frontend/api/client.js';

export async function load({ url }) {
  const page = url.searchParams.get('page') || '1';
  return await apiClient(`/api/products?page=${page}`);
}
EOF

cat << 'EOF' > src/routes/contacts/+page.server.js
/* ../contacts/+page.server.js */
export async function load() {
  return {};
}
EOF

cat << 'EOF' > src/lib/components/Header/Logo.svelte
/* ../../lib/components/Header/Logo.svelte */
let { title = "IFNEW" } = $props();
<a href="/" class="btn btn-ghost text-xl">{title}</a>
EOF

cat << 'EOF' > src/lib/components/Header/NavHeader.svelte
/* ../../lib/components/Header/NavHeader.svelte */
let { items = [] } = $props();
<ul class="menu menu-horizontal px-1">
  {#each items as item}
    <li><a href={item.slug}>{item.title}</a></li>
  {/each}
</ul>
EOF

cat << 'EOF' > src/lib/components/Header/ThemeSwitch.svelte
/* ../../lib/components/Header/ThemeSwitch.svelte */
import { getTheme, toggleTheme } from '$lib/stores/index.svelte.js';

let theme = $derived(getTheme());

<label class="swap swap-rotate btn btn-ghost">
  <input type="checkbox" checked={theme === 'dim'} onchange={toggleTheme} />
  <svg class="swap-on fill-current w-5 h-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z"/></svg>
  <svg class="swap-off fill-current w-5 h-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z"/></svg>
</label>
EOF

cat << 'EOF' > src/lib/components/Header/Header.svelte
/* ../../lib/components/Header/Header.svelte */
import Logo from './Logo.svelte';
import NavHeader from './NavHeader.svelte';
import ThemeSwitch from './ThemeSwitch.svelte';

const navItems = [
  { slug: '/', title: 'Главная' },
  { slug: '/company/', title: 'О компании' },
  { slug: '/products/', title: 'Товары' },
  { slug: '/contacts/', title: 'Контакты' }
];

<div class="navbar bg-base-100 shadow-sm sticky top-0 z-50">
  <div class="navbar-start">
    <div class="dropdown">
      <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" /></svg>
      </div>
      <ul tabindex="0" class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
        {#each navItems as item}
          <li><a href={item.slug}>{item.title}</a></li>
        {/each}
      </ul>
    </div>
    <Logo />
  </div>
  <div class="navbar-center hidden lg:flex">
    <NavHeader items={navItems} />
  </div>
  <div class="navbar-end gap-2">
    <span class="hidden">EN</span>
    <ThemeSwitch />
  </div>
</div>
EOF

cat << 'EOF' > src/lib/components/Footer/NavFooter.svelte
/* ../../lib/components/Footer/NavFooter.svelte */
let { items = [], title = "" } = $props();
<div>
  <h3 class="footer-title">{title}</h3>
  <ul class="flex flex-col gap-1">
    {#each items as item}
      <li><a class="link link-hover" href={item.slug}>{item.title}</a></li>
    {/each}
  </ul>
</div>
EOF

cat << 'EOF' > src/lib/components/Footer/ContactsFooter.svelte
/* ../../lib/components/Footer/ContactsFooter.svelte */
<div>
  <h3 class="footer-title">Контакты</h3>
  <ul class="flex flex-col gap-2">
    <li><a class="link link-hover" href="tel:+74951234567">+7 (495) 123-45-67</a></li>
    <li><a class="link link-hover" href="mailto:info@ifnew.ru">info@ifnew.ru</a></li>
    <li>г. Москва, ул. Примерная, д. 1</li>
  </ul>
</div>
EOF

cat << 'EOF' > src/lib/components/Footer/Copyright.svelte
/* ../../lib/components/Footer/Copyright.svelte */
const year = new Date().getFullYear();
<p>© 2013 - {year} IFNEW. Все права защищены.</p>
EOF

cat << 'EOF' > src/lib/components/Footer/Footer.svelte
/* ../../lib/components/Footer/Footer.svelte */
import NavFooter from './NavFooter.svelte';
import ContactsFooter from './ContactsFooter.svelte';
import Copyright from './Copyright.svelte';

const col1 = [
  { slug: '/', title: 'Главная' },
  { slug: '/company/', title: 'О компании' }
];
const col2 = [
  { slug: '/products/', title: 'Товары' },
  { slug: '/contacts/', title: 'Контакты' }
];

<footer class="bg-base-200 pt-10 pb-4 mt-auto">
  <div class="container mx-auto px-4">
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
      <NavFooter title="Компания" items={col1} />
      <NavFooter title="Информация" items={col2} />
      <ContactsFooter />
    </div>
    <div class="border-t border-base-300 pt-4 text-center text-base-content/60">
      <Copyright />
    </div>
  </div>
</footer>
EOF

cat << 'EOF' > src/lib/components/Home/HeroCarousel.svelte
/* ../../lib/components/Home/HeroCarousel.svelte */
let { items = [] } = $props();
<div class="carousel w-full rounded-box">
  {#each items as item, i}
    <div id={`slide-${i}`} class="carousel-item relative w-full">
      <img src={item.image} alt={item.title} class="w-full object-cover h-[250px] md:h-[400px]" />
      <div class="absolute left-0 top-0 h-full w-full bg-gradient-to-r from-black/60 to-transparent flex items-center pl-8 md:pl-16">
        <h2 class="text-2xl md:text-5xl font-bold text-white">{item.title}</h2>
      </div>
      <div class="absolute left-5 right-5 top-1/2 flex -translate-y-1/2 transform justify-between">
        <a href={`#slide-${i === 0 ? items.length - 1 : i - 1}`} class="btn btn-circle btn-sm md:btn-md">❮</a>
        <a href={`#slide-${i === items.length - 1 ? 0 : i + 1}`} class="btn btn-circle btn-sm md:btn-md">❯</a>
      </div>
    </div>
  {/each}
</div>
EOF

cat << 'EOF' > src/lib/components/Home/MainText.svelte
/* ../../lib/components/Home/MainText.svelte */
let { text = "" } = $props();
<div class="prose lg:prose-xl max-w-none py-8 px-4">
  <p class="text-lg leading-relaxed">{text}</p>
</div>
EOF

cat << 'EOF' > src/lib/components/Products/ProductCard.svelte
/* ../../lib/components/Products/ProductCard.svelte */
let { product = {} } = $props();
<div class="card bg-base-100 shadow-md">
  <figure><img src="https://placehold.co/600x400/e2e8f0/475569?text=Product" alt={product.title} class="h-48 w-full object-cover" /></figure>
  <div class="card-body">
    <h3 class="card-title">{product.title}</h3>
    <p>{product.description}</p>
    <div class="mt-4 flex items-center justify-between">
      <span class="text-lg font-semibold text-primary">{product.price}</span>
      <button class="btn btn-primary btn-sm">Подробнее</button>
    </div>
  </div>
</div>
EOF

cat << 'EOF' > src/lib/components/Products/ProductGrid.svelte
/* ../../lib/components/Products/ProductGrid.svelte */
import ProductCard from './ProductCard.svelte';
let { items = [] } = $props();
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  {#each items as item}
    <ProductCard product={item} />
  {/each}
</div>
EOF

cat << 'EOF' > src/lib/components/Products/Pagination.svelte
/* ../../lib/components/Products/Pagination.svelte */
let { currentPage = 1, totalPages = 1, basePath = "/products" } = $props();

function getUrl(page) {
  return page === 1 ? basePath : `${basePath}?page=${page}`;
}
<div class="join justify-center mt-8">
  {#each Array(totalPages) as _, i}
    <a href={getUrl(i + 1)} class="join-item btn btn-sm" class:btn-active={currentPage === i + 1}>{i + 1}</a>
  {/each}
</div>
EOF

cat << 'EOF' > src/lib/components/Contacts/ContactInfo.svelte
/* ../../lib/components/Contacts/ContactInfo.svelte */
<section class="card bg-base-100 shadow-md mb-8">
  <div class="card-body">
    <h2 class="card-title">Наши контакты</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
      <div>
        <p class="font-bold">Адрес:</p>
        <p>г. Москва, ул. Примерная, д. 1, офис 100</p>
      </div>
      <div>
        <p class="font-bold">Телефон:</p>
        <a href="tel:+74951234567" class="link link-primary">+7 (495) 123-45-67</a>
      </div>
    </div>
  </div>
</section>
EOF

cat << 'EOF' > src/lib/components/Contacts/ContactForm.svelte
/* ../../lib/components/Contacts/ContactForm.svelte */
import { apiClient } from '$lib/frontend/api/client.js';

let name = $state('');
let message = $state('');
let status = $state('');

async function handleSubmit(e) {
  e.preventDefault();
  status = 'loading';
  try {
    const res = await apiClient('/api/contacts', {
      method: 'POST',
      body: JSON.stringify({ name, message })
    });
    if (res.success) {
      status = 'success';
      name = ''; message = '';
    } else {
      status = 'error';
    }
  } catch { status = 'error'; }
}

<section class="card bg-base-100 shadow-md">
  <div class="card-body">
    <h2 class="card-title">Обратная связь</h2>
    <form onsubmit={handleSubmit} class="flex flex-col gap-4 mt-4">
      <input type="text" placeholder="Ваше имя" class="input input-bordered w-full" bind:value={name} required />
      <textarea class="textarea textarea-bordered w-full" placeholder="Ваше сообщение" bind:value={message} required></textarea>
      <button type="submit" class="btn btn-primary self-start" disabled={status === 'loading'}>
        {#if status === 'loading'}
          <span class="loading loading-spinner loading-sm"></span> Отправка...
        {:else}
          Отправить
        {/if}
      </button>
      {#if status === 'success'}
        <div role="alert" class="alert alert-success"><span>Сообщение успешно отправлено!</span></div>
      {/if}
      {#if status === 'error'}
        <div role="alert" class="alert alert-error"><span>Произошла ошибка при отправке.</span></div>
      {/if}
    </form>
  </div>
</section>
EOF

cat << 'EOF' > src/routes/+layout.svelte
/* ../+layout.svelte */
import Header from '$lib/components/Header/Header.svelte';
import Footer from '$lib/components/Footer/Footer.svelte';
import { getTheme } from '$lib/stores/index.svelte.js';
import { onMount } from 'svelte';

let theme = $derived(getTheme());

 $effect(() => {
  if (typeof document !== 'undefined') {
    document.documentElement.setAttribute('data-theme', theme);
  }
});

let { children } = $props();
<div class="min-h-screen flex flex-col bg-base-100 text-base-content">
  <Header />
  <main class="flex-1">
    {@render children()}
  </main>
  <Footer />
</div>
EOF

cat << 'EOF' > src/routes/+page.svelte
/* ../+page.svelte */
import HeroCarousel from '$lib/components/Home/HeroCarousel.svelte';
import MainText from '$lib/components/Home/MainText.svelte';

let { data } = $props();
<div class="container mx-auto">
  <HeroCarousel items={data.hero || []} />
  <MainText text={data.text || ''} />
</div>
EOF

cat << 'EOF' > src/routes/company/+page.svelte
/* ../company/+page.svelte */
let { data } = $props();
<div class="container mx-auto px-4 py-8 max-w-4xl">
  <h1 class="text-3xl font-bold mb-6">О компании</h1>
  <p class="text-lg leading-relaxed">{data.text}</p>
</div>
EOF

cat << 'EOF' > src/routes/products/+page.svelte
/* ../products/+page.svelte */
import ProductGrid from '$lib/components/Products/ProductGrid.svelte';
import Pagination from '$lib/components/Products/Pagination.svelte';

let { data } = $props();
<div class="container mx-auto px-4 py-8">
  <h1 class="text-3xl font-bold mb-8">Наши товары</h1>
  <ProductGrid items={data.items} />
  {#if data.totalPages > 1}
    <Pagination currentPage={data.page} totalPages={data.totalPages} />
  {/if}
</div>
EOF

cat << 'EOF' > src/routes/contacts/+page.svelte
/* ../contacts/+page.svelte */
import ContactInfo from '$lib/components/Contacts/ContactInfo.svelte';
import ContactForm from '$lib/components/Contacts/ContactForm.svelte';

<div class="container mx-auto px-4 py-8 max-w-4xl">
  <h1 class="text-3xl font-bold mb-8">Контакты</h1>
  <ContactInfo />
  <ContactForm />
</div>
EOF

cat << 'EOF' > src/routes/en/[slug]/+page.svelte
/* ../en/[slug]/+page.svelte */
<div class="min-h-[60vh] flex items-center justify-center">
  <div role="alert" class="alert alert-warning max-w-md">
    <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z" /></svg>
    <span>Sorry, English version not available yet</span>
  </div>
</div>
EOF

echo "Проект успешно сгенерирован!"