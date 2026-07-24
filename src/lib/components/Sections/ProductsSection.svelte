<script>
  import CardGrid from './Cards/CardGrid.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  const items = $derived(section.items || []);
  const viewMode = $derived(section.viewMode || 'list');

  let expandedCats = $state([]);

  function toggleCat(name) {
    if (expandedCats.includes(name)) {
      expandedCats = expandedCats.filter(n => n !== name);
    } else {
      expandedCats = [...expandedCats, name];
    }
  }

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
    <!-- for category -->
    <CardGrid items={items} type="products" />
    
  {:else}

    <!--  list -->
    <div class="bg-white rounded-box shadow-md w-full max-w-4xl mx-auto border border-gray-200 overflow-hidden mb-16">
      {#if grouped.noCategory.length > 0}
        {#each grouped.noCategory as item}
          <a href={normalizeSlug(item.slug, 'product')} class="block px-6 py-3 hover:bg-gray-50 transition-colors border-b border-gray-200 last:border-0">
            <span class="text-base text-secondary hover:text-primary transition-colors">
              {item.name || item.heading || item.title}
            </span>
          </a>
        {/each}
      {/if}

      {#each Array.from(grouped.groups.entries()) as [catName, group]}
        <div class="border-b border-gray-200 last:border-0">
          <div 
            class="flex items-center justify-between px-6 py-3 bg-white hover:bg-gray-50 transition-colors cursor-pointer select-none"
            onclick={() => toggleCat(catName)}
          >
            <a 
              href={`?category=${group.slug}`}
              class="text-base font-medium text-secondary hover:text-primary transition-colors flex-1"
              onclick={(e) => e.stopPropagation()}
            >
              {catName}
            </a>
            
            <button 
              type="button"
              class="p-2 text-gray-500 hover:text-primary transition-colors"
              onclick={(e) => { e.stopPropagation(); toggleCat(catName); }}
            >
              {#if expandedCats.includes(catName)}
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                </svg>
              {:else}
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              {/if}
            </button>
          </div>

          {#if expandedCats.includes(catName)}
            <div class="bg-gray-50/50">
              {#each group.items as item}
                <a href={normalizeSlug(item.slug, 'product')} class="block pl-10 pr-6 py-2 hover:bg-gray-100 transition-colors border-b border-gray-200/50 last:border-0">
                  <span class="text-sm text-gray-700 hover:text-primary transition-colors">
                    {item.name || item.heading || item.title}
                  </span>
                </a>
              {/each}
            </div>
          {/if}
        </div>
      {/each}
    </div>

    <!-- grid -->
    <div class="w-full">
      <h3 class="text-2xl font-bold text-center mb-8 text-secondary">Каталог продукции</h3>
      <CardGrid items={items} type="products" />
    </div>
  {/if}
</section>