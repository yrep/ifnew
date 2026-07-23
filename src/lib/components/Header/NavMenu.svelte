<script>
  import { page } from "$app/state";
  import { mainPages, isActivePage } from "$lib/common/routes.js";
  import { slide, fade } from "svelte/transition";
  import ContactBar from "./ContactBar.svelte";
  import { formatPhone } from "$lib/common/strings.js";

  const currentPath = $derived(page.url.pathname);

  let isOpen = $state(false);
  let touchStartX = $state(0);

  const phone = "+7 495 150 22 86";
  const email = "Interfeed.ru@bk.ru";

  function openMenu() {
    isOpen = true;
  }

  function closeMenu() {
    isOpen = false;
  }

  function handleTouchStart(e) {
    touchStartX = e.changedTouches[0].screenX;
  }

  function handleTouchEnd(e) {
    const delta = e.changedTouches[0].screenX - touchStartX;
    if (delta > 50) closeMenu();
    touchStartX = 0;
  }

  $effect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  });
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

<button class="btn btn-ghost btn-square md:hidden" aria-label="Открыть меню" onclick={openMenu}>
  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
  </svg>
</button>

{#if isOpen}
  <div class="fixed inset-0 z-100 md:hidden" transition:fade>
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" onclick={closeMenu}></div>
    
    <div
      class="absolute right-0 top-0 bottom-0 w-4/5 max-w-sm bg-white text-base-content shadow-2xl flex flex-col"
      transition:slide={{ axis: 'x', duration: 300 }}
      ontouchstart={handleTouchStart}
      ontouchend={handleTouchEnd}
    >
      <!-- Шапка мобильного меню -->
      <div class="flex items-center justify-between p-4 border-b border-base-200">
        <span class="font-bold text-lg">Меню</span>
        <button class="btn btn-ghost btn-square" aria-label="Закрыть меню" onclick={closeMenu}>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      
      <!-- Навигация -->
      <nav class="flex-1 overflow-y-auto p-4">
        <ul class="flex flex-col gap-2">
          {#each mainPages as p}
            <li>
              <a
                href={p.slug}
                class="text-xl font-semibold block py-2 hover:text-primary transition-colors"
                class:text-primary={isActivePage(currentPath, p.slug)}
                onclick={closeMenu}
              >
                {p.title}
              </a>
            </li>
          {/each}
        </ul>
      </nav>

      <!-- Контакты внизу меню -->
      <div class="border-t border-base-200 bg-base-100/50 p-4 space-y-3">
        <div class="text-xs uppercase tracking-wider text-base-content/50 font-semibold">Контакты</div>
        <a href={`tel:${phone.replace(/\s/g, '')}`} class="flex items-center gap-3 text-base-content hover:text-primary transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
          </svg>
          <span class="font-medium">{phone}</span>
        </a>
        <a href={`mailto:${email}`} class="flex items-center gap-3 text-base-content hover:text-primary transition-colors break-all">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
          </svg>
          <span class="font-medium">{email}</span>
        </a>
      </div>
    </div>
  </div>
{/if}

<style>
.mobile-nav a.active,
.menu a.active {
  color: var(--color-secondary) !important;
}
</style>