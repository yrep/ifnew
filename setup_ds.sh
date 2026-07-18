#!/usr/bin/env bash
# setup.sh – Svelte 5 runes + DaisyUI + SSR (final fix)

set -euo pipefail

BASE="src"
echo "Создаю структуру папок..."

rm -rf "$BASE" .svelte-kit vite.config.js jsconfig.json

mkdir -p $BASE/lib/components/Header \
         $BASE/lib/components/Footer \
         $BASE/lib/components/Hero \
         $BASE/lib/components/Products \
         $BASE/lib/components/Contacts \
         $BASE/lib/stores \
         $BASE/lib/server/api \
         $BASE/lib/frontend/api \
         $BASE/lib/common \
         $BASE/routes/company \
         $BASE/routes/products \
         $BASE/routes/contacts \
         "$BASE/routes/en/[...slug]" \
         $BASE/routes/api/page \
         $BASE/routes/api/contact


# app.html (без обертки, чтобы избежать потенциальных проблем)
cat > $BASE/app.html << 'EOF'
<!doctype html>
<html lang="ru" data-theme="emerald">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" href="%sveltekit.assets%/favicon.png" />
    %sveltekit.head%
  </head>
  <body>
    %sveltekit.body%
  </body>
</html>
EOF

# app.css
cat > $BASE/app.css << 'EOF'
@import "tailwindcss";
@plugin "@tailwindcss/typography";
@plugin "daisyui" {
  themes: emerald --default, dim;
}
EOF

# -------------------- STORES --------------------
cat > $BASE/lib/stores/theme.svelte.js << 'EOF'
let current = $state('emerald');
if (typeof window !== 'undefined') {
  const stored = localStorage.getItem('theme');
  if (stored === 'dim' || stored === 'emerald') current = stored;
}
export function getTheme() { return current; }
export function setTheme(theme) {
  if (theme !== 'emerald' && theme !== 'dim') return;
  current = theme;
  if (typeof window !== 'undefined') {
    localStorage.setItem('theme', theme);
    document.documentElement.setAttribute('data-theme', theme);
  }
}
EOF

cat > $BASE/lib/stores/locale.svelte.js << 'EOF'
let locale = $state('ru');
export function getLocale() { return locale; }
export function setLocale(lang) { locale = lang; }
EOF

# -------------------- COMMON --------------------
cat > $BASE/lib/common/utils.js << 'EOF'
export function currentYear() { return new Date().getFullYear(); }
EOF

# -------------------- SERVER API --------------------
cat > $BASE/lib/server/api/mockData.js << 'EOF'
export function getPageData(slug, locale, page = 1) {
  switch (slug) {
    case 'home':
      return {
        hero: [
          { title: 'Инновационные решения', subtitle: 'Для вашего бизнеса', image: 'https://placehold.co/1200x600/3B82F6/white?text=Slide+1' },
          { title: 'Качественные продукты', subtitle: 'Надёжность и стиль', image: 'https://placehold.co/1200x600/10B981/white?text=Slide+2' },
          { title: 'Профессиональная поддержка', subtitle: '24/7 на связи', image: 'https://placehold.co/1200x600/F59E0B/white?text=Slide+3' }
        ],
        text: 'Компания «Интерфид» — ваш надёжный партнёр в мире современных технологий и качественного оборудования.'
      };
    case 'company':
      return { text: 'Наша компания основана в 2013 году. Мы специализируемся на поставках высокотехнологичного оборудования и расходных материалов...' };
    case 'products': {
      const base = [
        { id: 1, title: 'Промышленный контроллер X1', description: 'Высокопроизводительное решение.', image: 'https://placehold.co/400x300/6366F1/white?text=X1' },
        { id: 2, title: 'Датчик температуры T-200', description: 'Высокоточный датчик.', image: 'https://placehold.co/400x300/EC4899/white?text=T-200' },
        { id: 3, title: 'Привод линейный L-50', description: 'Электромеханический привод.', image: 'https://placehold.co/400x300/14B8A6/white?text=L-50' }
      ];
      const perPage = 6, totalItems = 10, totalPages = Math.ceil(totalItems / perPage);
      const p = Math.min(Math.max(page, 1), totalPages);
      const items = Array.from({ length: totalItems }, (_, i) => ({ ...base[i % base.length], id: i + 1, title: `${base[i % base.length].title} (вариант ${i + 1})` }));
      const start = (p - 1) * perPage;
      return { products: items.slice(start, start + perPage), currentPage: p, totalPages, perPage };
    }
    case 'contacts':
      return { address: 'г. Москва, ул. Примерная, д. 15, офис 302', phone: '+7 (495) 123-45-67', email: 'info@interfeed.ru' };
    default: return {};
  }
}
EOF

# -------------------- FRONTEND API --------------------
cat > $BASE/lib/frontend/api/pageApi.js << 'EOF'
export async function fetchPageData(slug, locale = 'ru', page = 1, fetchFn = fetch) {
  const params = new URLSearchParams({ slug, locale });
  if (slug === 'products') params.set('page', String(page));
  const res = await fetchFn(`/api/page?${params.toString()}`);
  if (!res.ok) throw new Error(`Ошибка загрузки: ${res.status}`);
  return await res.json();
}
EOF

cat > $BASE/lib/frontend/api/contactApi.js << 'EOF'
export async function submitContactForm(formData) {
  const res = await fetch('/api/contact', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(formData)
  });
  if (!res.ok) throw new Error('Ошибка отправки');
  return await res.json();
}
EOF

# -------------------- COMPONENTS --------------------
cat > $BASE/lib/components/Header/Logo.svelte << 'EOF'
<a href="/" class="text-2xl font-bold tracking-tight text-primary">IFNew</a>
EOF

cat > $BASE/lib/components/Header/ThemeSwitch.svelte << 'EOF'
<script>
  import { getTheme, setTheme } from '$lib/stores/theme.svelte.js';
</script>
<label class="swap swap-rotate ml-4">
  <input type="checkbox" class="theme-controller"
    checked={getTheme() === 'dim'}
    onchange={(e) => setTheme(e.target.checked ? 'dim' : 'emerald')} />
  <svg class="swap-off h-6 w-6 fill-current" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z"/></svg>
  <svg class="swap-on h-6 w-6 fill-current" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z"/></svg>
</label>
EOF

cat > $BASE/lib/components/Header/NavHeader.svelte << 'EOF'
<script>
  const pages = [
    { slug: '', title: 'Главная' },
    { slug: 'company', title: 'О компании' },
    { slug: 'products', title: 'Продукты' },
    { slug: 'contacts', title: 'Контакты' }
  ];
</script>
<ul class="menu menu-horizontal px-1 gap-1 hidden md:flex">
  {#each pages as page}
    <li><a href="/{page.slug}" class="font-medium">{page.title}</a></li>
  {/each}
</ul>
<div class="dropdown md:hidden">
  <button class="btn btn-ghost btn-circle" aria-label="Меню">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7" /></svg>
  </button>
  <ul class="menu menu-sm dropdown-content mt-3 z-[1] p-2 shadow bg-base-100 rounded-box w-52">
    {#each pages as page}
      <li><a href="/{page.slug}">{page.title}</a></li>
    {/each}
  </ul>
</div>
EOF

cat > $BASE/lib/components/Header/Header.svelte << 'EOF'
<script>
  import Logo from './Logo.svelte';
  import NavHeader from './NavHeader.svelte';
  import ThemeSwitch from './ThemeSwitch.svelte';
</script>
<header class="navbar bg-base-100 shadow-sm px-4 md:px-8">
  <div class="navbar-start"><Logo /></div>
  <div class="navbar-center hidden md:flex"><NavHeader /></div>
  <div class="navbar-end flex items-center gap-2"><NavHeader /><ThemeSwitch /></div>
</header>
EOF

cat > $BASE/lib/components/Footer/FooterContacts.svelte << 'EOF'
<script>
  let { address = '', phone = '', email = '' } = $props();
</script>
<div>
  <h3 class="text-lg font-semibold mb-2">Контакты</h3>
  <p>{address}</p>
  <p class="mt-1"><a href="tel:{phone}" class="link link-hover">{phone}</a></p>
  <p class="mt-1"><a href="mailto:{email}" class="link link-hover">{email}</a></p>
</div>
EOF

cat > $BASE/lib/components/Footer/NavFooter.svelte << 'EOF'
<script>
  const leftLinks = [
    { slug: '', title: 'Главная' },
    { slug: 'company', title: 'О компании' }
  ];
  const rightLinks = [
    { slug: 'products', title: 'Продукты' },
    { slug: 'contacts', title: 'Контакты' }
  ];
</script>
<div class="flex gap-12 flex-wrap">
  <div><ul class="space-y-1">{#each leftLinks as link}<li><a href="/{link.slug}" class="link link-hover">{link.title}</a></li>{/each}</ul></div>
  <div><ul class="space-y-1">{#each rightLinks as link}<li><a href="/{link.slug}" class="link link-hover">{link.title}</a></li>{/each}</ul></div>
</div>
EOF

cat > $BASE/lib/components/Footer/Copyright.svelte << 'EOF'
<script>
  import { currentYear } from '$lib/common/utils.js';
</script>
<div class="text-center text-sm opacity-70 mt-8">© 2013 – {currentYear()} IFNew. Все права защищены.</div>
EOF

cat > $BASE/lib/components/Footer/Footer.svelte << 'EOF'
<script>
  import NavFooter from './NavFooter.svelte';
  import FooterContacts from './FooterContacts.svelte';
  import Copyright from './Copyright.svelte';
  let { contacts = { address: '', phone: '', email: '' } } = $props();
</script>
<footer class="footer bg-base-200 text-base-content p-10 mt-10">
  <div class="max-w-7xl mx-auto w-full flex flex-col md:flex-row justify-between gap-8">
    <NavFooter />
    <FooterContacts {...contacts} />
  </div>
  <div class="max-w-7xl mx-auto w-full mt-6 border-t border-base-300 pt-4">
    <Copyright />
  </div>
</footer>
EOF

cat > $BASE/lib/components/Hero/HeroCarousel.svelte << 'EOF'
<script>
  let { items = [] } = $props();
</script>
{#if items.length > 0}
  <div class="carousel w-full rounded-box overflow-hidden">
    {#each items as item, index}
      <div id="slide{index}" class="carousel-item relative w-full">
        <img src={item.image} alt={item.title} class="w-full object-cover h-64 md:h-96" />
        <div class="absolute inset-0 flex flex-col justify-center items-center bg-black/40 p-6 text-white text-center">
          <h2 class="text-3xl md:text-5xl font-bold">{item.title}</h2>
          {#if item.subtitle}<p class="mt-2 text-lg md:text-2xl">{item.subtitle}</p>{/if}
        </div>
        <div class="absolute left-5 right-5 top-1/2 flex -translate-y-1/2 transform justify-between">
          <a href="#slide{index === 0 ? items.length - 1 : index - 1}" class="btn btn-circle btn-sm opacity-70">❮</a>
          <a href="#slide{index === items.length - 1 ? 0 : index + 1}" class="btn btn-circle btn-sm opacity-70">❯</a>
        </div>
      </div>
    {/each}
  </div>
{/if}
EOF

cat > $BASE/lib/components/Products/ProductCard.svelte << 'EOF'
<script>
  let { product } = $props();
</script>
<div class="card bg-base-100 shadow-xl">
  <figure class="px-4 pt-4"><img src={product.image} alt={product.title} class="rounded-xl h-48 w-full object-cover" /></figure>
  <div class="card-body items-center text-center">
    <h3 class="card-title">{product.title}</h3>
    <p>{product.description}</p>
  </div>
</div>
EOF

cat > $BASE/lib/components/Products/ProductsGrid.svelte << 'EOF'
<script>
  import ProductCard from './ProductCard.svelte';
  let { products = [] } = $props();
</script>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  {#each products as product}
    <ProductCard {product} />
  {/each}
</div>
EOF

cat > $BASE/lib/components/Products/Pagination.svelte << 'EOF'
<script>
  let { currentPage = 1, totalPages = 1 } = $props();
  const pages = Array.from({ length: totalPages }, (_, i) => i + 1);
</script>
{#if totalPages > 1}
  <div class="join mt-8 justify-center flex">
    <a href="?page={currentPage - 1}" class="join-item btn" class:btn-disabled={currentPage <= 1}>«</a>
    {#each pages as page}
      <a href="?page={page}" class="join-item btn" class:btn-active={page === currentPage}>{page}</a>
    {/each}
    <a href="?page={currentPage + 1}" class="join-item btn" class:btn-disabled={currentPage >= totalPages}>»</a>
  </div>
{/if}
EOF

cat > $BASE/lib/components/Contacts/ContactForm.svelte << 'EOF'
<script>
  import { submitContactForm } from '$lib/frontend/api/contactApi.js';
  let name = $state('');
  let email = $state('');
  let message = $state('');
  let status = $state('');
  async function handleSubmit(e) {
    e.preventDefault();
    status = '';
    try {
      await submitContactForm({ name, email, message });
      status = 'success'; name = email = message = '';
    } catch { status = 'error'; }
  }
</script>
<form onsubmit={handleSubmit} class="card bg-base-100 shadow-xl p-6 max-w-lg mx-auto">
  <h2 class="text-2xl font-bold mb-4">Обратная связь</h2>
  <div class="form-control mb-4"><label class="label" for="name">Имя</label><input id="name" type="text" bind:value={name} required class="input input-bordered" /></div>
  <div class="form-control mb-4"><label class="label" for="email">Email</label><input id="email" type="email" bind:value={email} required class="input input-bordered" /></div>
  <div class="form-control mb-6"><label class="label" for="message">Сообщение</label><textarea id="message" bind:value={message} required rows="4" class="textarea textarea-bordered"></textarea></div>
  <button type="submit" class="btn btn-primary">Отправить</button>
  {#if status === 'success'}<div class="alert alert-success mt-4">Сообщение отправлено!</div>{/if}
  {#if status === 'error'}<div class="alert alert-error mt-4">Ошибка отправки. Попробуйте позже.</div>{/if}
</form>
EOF

# -------------------- ROUTES with layout data loading --------------------
# +layout.js загружает контакты для футера
cat > $BASE/routes/+layout.js << 'EOF'
import { fetchPageData } from '$lib/frontend/api/pageApi.js';
/** @param { import('@sveltejs/kit').LayoutLoadEvent } event */
export async function load({ fetch }) {
  const contacts = await fetchPageData('contacts', 'ru', 1, fetch);
  return { contacts };
}
EOF

cat > $BASE/routes/+layout.svelte << 'EOF'
<script>
  import { getTheme } from '$lib/stores/theme.svelte.js';
  import Header from '$lib/components/Header/Header.svelte';
  import Footer from '$lib/components/Footer/Footer.svelte';
  let { children, data } = $props();
  $effect(() => {
    if (typeof document !== 'undefined') document.documentElement.setAttribute('data-theme', getTheme());
  });
</script>
<div class="flex flex-col min-h-screen">
  <Header />
  <main class="flex-grow container mx-auto px-4 md:px-8 py-6">{@render children()}</main>
  <Footer contacts={data.contacts} />
</div>
EOF

# Главная страница
cat > $BASE/routes/+page.js << 'EOF'
import { fetchPageData } from '$lib/frontend/api/pageApi.js';
export async function load({ fetch }) { return await fetchPageData('home', 'ru', 1, fetch); }
EOF

cat > $BASE/routes/+page.svelte << 'EOF'
<script>
  import HeroCarousel from '$lib/components/Hero/HeroCarousel.svelte';
  let { data } = $props();
</script>
<HeroCarousel items={data.hero} />
<section class="prose max-w-none mt-8"><p>{data.text}</p></section>
EOF

# Company
cat > $BASE/routes/company/+page.js << 'EOF'
import { fetchPageData } from '$lib/frontend/api/pageApi.js';
export async function load({ fetch }) { return await fetchPageData('company', 'ru', 1, fetch); }
EOF

cat > $BASE/routes/company/+page.svelte << 'EOF'
<script>
  let { data } = $props();
</script>
<article class="prose max-w-none"><h1>О компании</h1><p>{data.text}</p></article>
EOF

# Products
cat > $BASE/routes/products/+page.js << 'EOF'
import { fetchPageData } from '$lib/frontend/api/pageApi.js';
export async function load({ url, fetch }) {
  const page = Number(url.searchParams.get('page')) || 1;
  return await fetchPageData('products', 'ru', page, fetch);
}
EOF

cat > $BASE/routes/products/+page.svelte << 'EOF'
<script>
  import ProductsGrid from '$lib/components/Products/ProductsGrid.svelte';
  import Pagination from '$lib/components/Products/Pagination.svelte';
  let { data } = $props();
</script>
<h1 class="text-3xl font-bold mb-6">Продукты</h1>
<ProductsGrid products={data.products} />
<Pagination currentPage={data.currentPage} totalPages={data.totalPages} />
EOF

# Contacts
cat > $BASE/routes/contacts/+page.js << 'EOF'
import { fetchPageData } from '$lib/frontend/api/pageApi.js';
export async function load({ fetch }) { return await fetchPageData('contacts', 'ru', 1, fetch); }
EOF

cat > $BASE/routes/contacts/+page.svelte << 'EOF'
<script>
  import ContactForm from '$lib/components/Contacts/ContactForm.svelte';
  let { data } = $props();
</script>
<section class="mb-10">
  <h1 class="text-3xl font-bold mb-4">Контакты</h1>
  <div class="grid md:grid-cols-2 gap-8">
    <div>
      <h2 class="text-xl font-semibold mb-2">Наш адрес</h2>
      <p>{data.address}</p>
      <p class="mt-2"><strong>Телефон:</strong> <a href="tel:{data.phone}" class="link link-hover">{data.phone}</a></p>
      <p><strong>Email:</strong> <a href="mailto:{data.email}" class="link link-hover">{data.email}</a></p>
    </div>
    <div><ContactForm /></div>
  </div>
</section>
EOF

# English catch-all
cat > "$BASE/routes/en/[...slug]/+page.svelte" << 'EOF'
<div class="alert alert-warning max-w-lg mx-auto mt-20">
  <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4.5c-.77-.833-2.694-.833-3.464 0L3.34 16.5c-.77.833.192 2.5 1.732 2.5z" /></svg>
  <span>Sorry, English version not available yet.</span>
</div>
EOF

# API routes
cat > $BASE/routes/api/page/+server.js << 'EOF'
import { json } from '@sveltejs/kit';
import { getPageData } from '$lib/server/api/mockData.js';
export function GET({ url }) {
  const slug = url.searchParams.get('slug') || 'home';
  const locale = url.searchParams.get('locale') || 'ru';
  const page = parseInt(url.searchParams.get('page') || '1', 10);
  return json(getPageData(slug, locale, page));
}
EOF

cat > $BASE/routes/api/contact/+server.js << 'EOF'
import { json } from '@sveltejs/kit';
export async function POST({ request }) {
  const body = await request.json();
  console.log('Contact form submitted:', body);
  return json({ success: true });
}
EOF

echo "✅ Готово. Выполните: pnpm install && pnpm dev"