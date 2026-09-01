<script>
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  import { sortProductsByOrder } from '$lib/common/productSort.js';

  let { items } = $props();

  const itemClass = "badge bg-white text-base-content border border-base-200 hover:bg-accent hover:text-accent-content hover:border-accent transition-colors cursor-pointer text-sm font-medium px-4 h-14 flex items-center justify-center text-center leading-snug";

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

    categoriesArray.sort((a, b) => (a.order || 0) - (b.order || 0));

    return { products: sortedProds, categories: categoriesArray };
  });
</script>

<div class="flex flex-wrap gap-3 w-full">
  {#each products as item}
    <a
      href={normalizeSlug(item.slug, 'product')}
      class={`${itemClass} flex-1 min-w-[180px] max-w-xs`}
    >
      {item.name || item.heading || item.title}
    </a>
  {/each}

  {#each categories as category}
    <a
      href={normalizeSlug(category.slug, 'category')}
      class={`${itemClass} flex-1 min-w-[180px] max-w-xs`}
    >
      {category.name}
    </a>
  {/each}
</div>