<!-- src/routes/sitemap/+page.svelte -->
<script>
  import Breadcrumbs from '$lib/components/Breadcrumbs.svelte';
  
  let { data } = $props();
  const sitemap = $derived(data.sitemap || []);

  function handleLinkClick(e) {
    e.stopPropagation();
  }
</script>

<main class="w-full max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
  <Breadcrumbs currentTitle="Карта сайта" />
  
  <h1 class="text-3xl font-bold mb-8">Карта сайта</h1>

  <div class="space-y-2">
    {#each sitemap as page}
      {#if page.children && page.children.length > 0}
        <div class="collapse collapse-arrow bg-base-100 border border-base-300">
          <input type="checkbox" />
          <div class="collapse-title font-semibold">
            <a href={page.slug} onclick={handleLinkClick}>
              {page.title}
            </a>
          </div>
          <div class="collapse-content text-sm">
            <ul>
              {#each page.children as child}
                <li>
                  <a href={child.slug}>{child.title}</a>
                </li>
              {/each}
            </ul>
          </div>
        </div>

      {:else}
        <a href={page.slug} class="inline-block py-2 hover:text-primary hover:underline">
          {page.title}
        </a>
      {/if}
    {/each}
  </div>
</main>