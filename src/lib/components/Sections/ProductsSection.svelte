<script>
  import ProductsList from './ProductsList.svelte';
  import ProductsGrid from './ProductsGrid.svelte';
  import CategoryProductList from './CategoryProductList.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  import { page } from '$app/state';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  const sectionCode = $derived(sectionDef.code || '');
  const items = $derived(section.items || []);
  
  const currentCategory = $derived(page.url.searchParams.get('category'));
  const currentCategoryName = $derived(items.find(item => item.category?.name)?.category?.name || currentCategory);

  const isListMode = $derived(sectionCode === 'products_list_main');
  const isGridMode = $derived(sectionCode === 'products_grid_main');
</script>

<section class="py-8 w-full">
  {#if sectionDef.show_heading_excerpt && !currentCategory}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{sectionDef.heading}</h2>
      {#if sectionDef.excerpt}
        <p class="mt-2 text-base-content/70">{sectionDef.excerpt}</p>
      {/if}
    </div>
  {/if}

  {#if currentCategory}
    {#if sectionCode === 'products_list_main' || !sectionCode}
      <div class="max-w-4xl mx-auto">
        <a 
          href={page.url.pathname} 
          class="inline-flex items-center gap-2 text-sm text-base-content/60 hover:text-primary transition-colors mb-6"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
          Вернуться ко всем товарам
        </a>

        <h2 class="text-2xl font-bold mb-6 text-secondary">
          {currentCategoryName}
        </h2>

        <CategoryProductList items={items} />
      </div>
    {/if}

  {:else if isGridMode}
    <ProductsGrid items={items} />

  {:else if isListMode}
    <ProductsList items={items} />

  {:else}
    <ProductsGrid items={items} />
  {/if}
</section>