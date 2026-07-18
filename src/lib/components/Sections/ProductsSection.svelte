<script>
  import CardGrid from './Cards/CardGrid.svelte';
  import Pagination from '$lib/components/Common/Pagination.svelte';
  import { page } from '$app/state';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  
  const currentPage = $derived(parseInt(page.url.searchParams.get('page') || '1', 10));
  const totalPages = $derived(section.totalPages || 1);
  const basePath = $derived(page.url.pathname);
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

  <CardGrid items={section.items || []} type="products" />
  
  <Pagination {currentPage} {totalPages} {basePath} />
</section>