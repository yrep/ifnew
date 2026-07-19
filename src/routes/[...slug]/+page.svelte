<!-- src/routes/[...slug]/+page.svelte -->
<script>
  import PageBuilder from '$lib/components/PageBuilder.svelte';
  import { dlog } from '$lib/common/dlog.js';
  
  let { data } = $props();

  dlog('Page data loaded:', data);
  
  const page = $derived(data.pageData?.page || {});
  const raw = $derived(page.raw || {});
  
  const title = $derived(raw.meta_title || page.title || 'IFNEW');
  const description = $derived(raw.meta_description || '');
  const keywords = $derived(raw.meta_keywords || '');
</script>

<svelte:head>
  <title>{title}</title>
  
  {#if description}
    <meta name="description" content={description} />
    <meta property="og:description" content={description} />
  {/if}
  
  {#if keywords}
    <meta name="keywords" content={keywords} />
  {/if}
  
  {#if page.image}
    <meta property="og:image" content={page.image} />
  {/if}
</svelte:head>

<PageBuilder data={data.pageData} />