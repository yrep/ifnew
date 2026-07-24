<script>
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
</script>

<div class="flex flex-wrap gap-2 justify-center">
  {#each products as item}
    <a
      href={normalizeSlug(item.slug, 'product')}
      class="badge bg-white text-base-content border border-base-200 hover:bg-accent hover:text-accent-content hover:border-accent transition-colors cursor-pointer text-sm font-normal px-4 py-3"
    >
      {item.name || item.heading || item.title}
    </a>
  {/each}

  {#each categories as [catName, group]}
    <div class="dropdown dropdown-hover">
      <div
        tabindex="0"
        role="button"
        class="badge bg-white text-base-content border border-base-200 hover:bg-accent hover:text-accent-content hover:border-accent transition-colors cursor-pointer text-sm font-normal px-4 py-3"
      >
        {catName}
        <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3 ml-1 inline" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </div>
      <ul tabindex="0" class="dropdown-content menu bg-white rounded-box z-[1] w-64 p-2 shadow-lg border border-base-200">
        {#each group.items as item}
          <li>
            <a
              href={normalizeSlug(item.slug, 'product')}
              class="text-sm hover:bg-base-200 rounded"
            >
              {item.name || item.heading || item.title}
            </a>
          </li>
        {/each}
        <li class="mt-1 pt-1 border-t border-base-200">
          <a
            href={`?category=${group.slug}`}
            class="text-sm text-primary font-medium hover:bg-base-200 rounded"
          >
            Все продукты категории →
          </a>
        </li>
      </ul>
    </div>
  {/each}
</div>