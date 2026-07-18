<script>
  import CardList from './Cards/CardList.svelte';
  import Pagination from '$lib/components/Common/Pagination.svelte';
  import { page } from '$app/state';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  
  const currentPage = $derived(parseInt(page.url.searchParams.get('page') || '1', 10));
  const totalPages = $derived(section.totalPages || 1);
  const basePath = $derived(page.url.pathname);
  
  const isPreview = $derived(page.url.pathname !== '/news/' && page.url.pathname !== '/news');
  
  // TODO to config
  const displayItems = $derived(isPreview ? (section.items || []).slice(0, 3) : (section.items || []));
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

  <CardList items={displayItems} type="news" />
  
  {#if isPreview && (section.items || []).length > 3}
    <div class="mt-10 text-center">
      <a href="/news/" class="btn btn-outline btn-primary">
        Перейти к разделу новостей
      </a>
    </div>
  {:else if !isPreview && totalPages > 1}
    <Pagination {currentPage} {totalPages} {basePath} />
  {/if}
</section>