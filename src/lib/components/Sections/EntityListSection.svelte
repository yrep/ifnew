<script>
  import CardGrid from './Cards/CardGrid.svelte';
  import Pagination from '$lib/components/Common/Pagination.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  import { page } from '$app/state';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  const items = $derived(section.items || []);
  const viewMode = $derived(section.viewMode || 'list');
  
  const currentPage = $derived(parseInt(page.url.searchParams.get('page') || '1', 10));
  const totalPages = $derived(section.totalPages || 1);
  const basePath = $derived(page.url.pathname);

  const grouped = $derived.by(() => {
    const groups = new Map();
    const noCategory = [];

    for (const item of items) {
      if (item.category) {
        const catName = item.category.name || 'Unknown';
        const catSlug = item.category.slug || '';
        if (!groups.has(catName)) {
          groups.set(catName, { slug: catSlug, items: [] });
        }
        groups.get(catName).items.push(item);
      } else {
        noCategory.push(item);
      }
    }
    return { groups, noCategory };
  });
</script>

<section class="py-8 w-full">
  {#if sectionDef.show_heading_excerpt}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{sectionDef.heading}</h2>
      {#if sectionDef.excerpt}
        <p class="mt-2 text-base-content/70">{sectionDef.excerpt}</p>
      {/if}
    </div>
  {/if}

  {#if viewMode === 'grid'}
    <CardGrid items={items} type="products" />
    {#if totalPages > 1}
      <Pagination {currentPage} {totalPages} {basePath} />
    {/if}
  {:else}
    <ul class="list bg-white rounded-box shadow-md w-full max-w-4xl mx-auto border border-base-200">
      {#if grouped.noCategory.length > 0}
        {#each grouped.noCategory as item}
          <li class="list-row hover:bg-neutral/10 transition-colors cursor-pointer border-b border-base-200 last:border-0">
            <a href={normalizeSlug(item.slug, 'product')} class="w-full h-full flex items-center py-3">
              <div class="flex-1">
                <div class="font-medium text-secondary hover:text-primary transition-colors text-lg">
                  {item.name || item.heading || item.title}
                </div>
              </div>
            </a>
          </li>
        {/each}
      {/if}

      {#each Array.from(grouped.groups.entries()) as [catName, group]}
        <li class="p-4 pb-2 text-xs uppercase font-semibold tracking-wide text-base-content/60 border-b border-base-200 mt-6 first:mt-0 bg-white rounded-t-box">
          {#if group.slug}
            <a href={`?category=${group.slug}`} class="text-secondary hover:text-primary transition-colors flex items-center gap-2">
              <span>{catName}</span>
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
              </svg>
            </a>
          {:else}
            {catName}
          {/if}
        </li>
        
        {#each group.items as item}
          <li class="list-row hover:bg-neutral/10 transition-colors cursor-pointer border-b border-base-200 last:border-0 pl-4 sm:pl-8">
            <a href={normalizeSlug(item.slug, 'product')} class="w-full h-full flex items-center py-3">
              <div class="flex-1">
                <div class="font-medium text-secondary hover:text-primary transition-colors text-lg">
                  {item.name || item.heading || item.title}
                </div>
              </div>
            </a>
          </li>
        {/each}
      {/each}
    </ul>
  {/if}
</section>