<script>
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { items } = $props();

  const itemClass = "badge bg-white text-base-content border border-base-200 hover:bg-accent hover:text-accent-content hover:border-accent transition-colors cursor-pointer text-sm font-medium px-4 h-14 flex items-center justify-center text-center leading-snug";

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

<div class="flex flex-wrap gap-3 w-full">
  {#each products as item}
    <a
      href={normalizeSlug(item.slug, 'product')}
      class={`${itemClass} flex-1 min-w-[180px] max-w-xs`}
    >
      {item.name || item.heading || item.title}
    </a>
  {/each}

  {#each categories as [catName, group]}
    <div class="dropdown dropdown-hover flex-1 min-w-[180px] max-w-xs">
      <div
        tabindex="0"
        role="button"
        class={itemClass}
      >
        <span class="truncate">{catName}</span>
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-1.5 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
      </div>
      
      <ul tabindex="0" class="dropdown-content menu bg-white rounded-box z-[1] w-full min-w-[220px] p-2 shadow-lg border border-base-200">
        {#each group.items as item}
          <li>
            <a
              href={normalizeSlug(item.slug, 'product')}
              class="text-sm py-2.5 hover:bg-base-200 rounded text-center leading-snug"
            >
              {item.name || item.heading || item.title}
            </a>
          </li>
        {/each}
        <li class="mt-1 pt-1 border-t border-base-200">
          <a
            href={`?category=${group.slug}`}
            class="text-sm text-primary font-semibold hover:bg-base-200 rounded text-center py-2.5"
          >
            Все продукты категории →
          </a>
        </li>
      </ul>
    </div>
  {/each}
</div>