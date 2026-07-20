<!-- src/lib/components/Header/NavMenu.svelte -->
<script>
  import { page } from "$app/state";
  import { mainPages, isActivePage } from "$lib/common/routes.js";
  import { slide, fade } from "svelte/transition";

  let { children } = $props();
  const currentPath = $derived(page.url.pathname);

  let isOpen = $state(false);
  let touchStartX = $state(0);

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
      class="absolute right-0 top-0 bottom-0 w-4/5 max-w-sm bg-base-100 text-base-content shadow-2xl flex flex-col"
      transition:slide={{ axis: 'x', duration: 300 }}
      ontouchstart={handleTouchStart}
      ontouchend={handleTouchEnd}
    >
      <div class="flex items-center justify-between p-4 border-b border-base-200">
        {@render children()}
        <button class="btn btn-ghost btn-square" aria-label="Закрыть меню" onclick={closeMenu}>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
      
      <nav class="flex-1 overflow-y-auto p-4">
        <ul class="flex flex-col gap-4">
          {#each mainPages as p}
            <li>
              <a
                href={p.slug}
                class="text-2xl font-semibold block py-2 hover:text-primary transition-colors"
                class:text-perimary={isActivePage(currentPath, p.slug)}
                onclick={closeMenu}
              >
                {p.title}
              </a>
            </li>
          {/each}
        </ul>
      </nav>
    </div>
  </div>
{/if}

<style>
.mobile-nav a.active,
.menu a.active {
  color: var(--color-secondary) !important;
}
</style>