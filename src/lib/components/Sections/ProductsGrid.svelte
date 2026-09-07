<script>
  import ProductCard from './Cards/ProductCard.svelte';
  import CategoryCard from './Cards/CategoryCard.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  import { sortProductsByOrder } from '$lib/common/productSort.js';

  let { items } = $props();

  const { products, categories } = $derived.by(() => {
    const prods = [];
    const cats = new Map();

    for (const item of items) {
      if (item.category) {
        const cat = item.category;
        const catName = cat.name || 'Unknown';
        if (!cats.has(catName)) {
          cats.set(catName, { ...cat, items: [] });
        }
        cats.get(catName).items.push(item);
      } else {
        prods.push(item);
      }
    }

    const sortedProds = sortProductsByOrder(prods);

    const categoriesArray = Array.from(cats.entries()).map(([name, group]) => ({
      name,
      ...group,
      items: sortProductsByOrder(group.items),
    }));

    categoriesArray.sort((a, b) => {
      const aOrder = a.order || 0;
      const bOrder = b.order || 0;
      return aOrder - bOrder;
    });

    return { products: sortedProds, categories: categoriesArray };
  });

  const gridItems = $derived([
    ...products.map(p => ({ type: 'product', item: p })),
    ...categories.map(cat => ({ type: 'category', category: cat })),
  ]);
</script>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 auto-rows-fr">
  {#each gridItems as entry}
    {#if entry.type === 'product'}
      <ProductCard item={entry.item} />
    {:else}
      <CategoryCard category={entry.category} />
    {/if}
  {/each}
</div>