<script>
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { items } = $props();
</script>

<ul class="flex flex-col gap-2 w-full">
  {#each items as item}
    <li class="bg-white border border-gray-200 rounded hover:bg-gray-50 transition-colors">
      <a 
        href={normalizeSlug(item.slug, 'product')} 
        class="block px-6 py-4 flex items-center justify-between group"
      >
        <span class="text-base font-medium text-secondary group-hover:text-primary transition-colors">
          {item.name || item.heading || item.title}
        </span>
        
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-base-content/30 group-hover:text-primary group-hover:translate-x-1 transition-all" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </a>
    </li>
  {/each}
  
  {#if items.length === 0}
    <li class="text-center py-8 text-base-content/60 bg-white border border-gray-200 rounded">
      В этой категории пока нет товаров.
    </li>
  {/if}
</ul>