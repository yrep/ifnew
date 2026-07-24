<script>
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { category, items, maxVisible = 5 } = $props();

  const visibleItems = $derived(items.slice(0, maxVisible));
  const hasMore = $derived(items.length > maxVisible);
  const categorySlug = $derived(category?.slug || '');
</script>

<a
  href={normalizeSlug(categorySlug, 'category')}
  class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow border border-base-200 overflow-hidden group h-full flex flex-col"
>
  <div class="flex flex-col flex-1">
    
    <!-- Заголовок категории - компактнее -->
    <div class="px-4 py-2 border-b border-base-200 bg-base-100">
      <h3 class="text-sm font-bold text-secondary group-hover:text-primary transition-colors flex items-center justify-between">
        <span class="truncate">{category?.name || 'Категория'}</span>
        <span class="text-xs text-base-content/60 font-medium bg-base-200 px-1.5 py-0.5 rounded-full flex-shrink-0 ml-2">
          {items.length}
        </span>
      </h3>
    </div>

    <ul class="list bg-base-100 flex-1">
      {#each visibleItems as item}
        <li class="list-row hover:bg-base-200/50 transition-colors cursor-pointer">
          <a 
            href={normalizeSlug(item.slug, 'product')}
            class="flex-1 flex items-center gap-2 py-1.5 px-3"
            onclick={(e) => e.stopPropagation()}
          >
            <div class="size-6 rounded bg-base-200 flex items-center justify-center text-base-content/40 flex-shrink-0">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </div>
            
            <div class="flex-1 min-w-0">
              <div class="text-xs font-medium text-base-content group-hover/item:text-primary transition-colors truncate">
                {item.name || item.heading || item.title}
              </div>
            </div>
          </a>
        </li>
      {/each}

      {#if hasMore}
        <li class="list-row hover:bg-base-200/50 transition-colors cursor-pointer border-t border-base-200">
          <a 
            href={`/produkciya/?category=${categorySlug}`}
            class="flex-1 flex items-center justify-center gap-1 py-2 text-xs font-semibold text-primary group-hover:text-accent transition-colors"
            onclick={(e) => e.stopPropagation()}
          >
            Показать все ({items.length})
            <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
            </svg>
          </a>
        </li>
      {/if}
    </ul>

  </div>
</a>