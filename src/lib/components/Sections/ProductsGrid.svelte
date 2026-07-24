<script>
  import ProductCard from './Cards/ProductCard.svelte';
  import CategoryCard from './Cards/CategoryCard.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { items } = $props();

  const { products, categories } = $derived.by(() => {
    const prods = [];
    const cats = new Map();

    for (const item of items) {
      if (item.category) {
        const catName = item.category.name || 'Unknown';
        const catSlug = item.category.slug || '';
        if (!cats.has(catName)) {
          cats.set(catName, { slug: catSlug, items: [] });
        }
        cats.get(catName).items.push(item);
      } else {
        prods.push(item);
      }
    }
    return { products: prods, categories: Array.from(cats.entries()) };
  });

  const gridItems = $derived([
    ...products.map(p => ({ type: 'product', item: p })),
    ...categories.map(([name, group]) => ({ type: 'category', name, ...group }))
  ]);
</script>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 auto-rows-fr">
  {#each gridItems as entry}
    {#if entry.type === 'product'}
      <ProductCard item={entry.item} />
    {:else}
      <CategoryCard category={{ name: entry.name, slug: entry.slug }} items={entry.items} maxVisible={5} />
    {/if}
  {/each}
</div>