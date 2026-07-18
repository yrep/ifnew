<script>
  import Image from '$lib/components/Common/Image.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { items, type = 'news' } = $props();

  function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
  }
</script>

<div class="flex flex-col gap-6">
  {#each items as item (item.id)}
    
    {#if type === 'partners'}
      <div class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow border border-base-200 flex-row overflow-hidden">
        {#if item.logo}
          <figure class="w-1/4 sm:w-1/5 h-full min-h-[120px] bg-base-200 flex items-center justify-center p-4">
            <Image 
              src={`http://127.0.0.1:8090/api/files/section_items_partners/${item.id}/${item.logo}`} 
              alt={item.name} 
              class="w-full h-full"
              objectFit="contain"
            />
          </figure>
        {/if}
        <div class="card-body flex-1 justify-center">
          <h3 class="card-title text-lg sm:text-xl">{item.name}</h3>
          {#if item.country}
            <p class="text-sm text-base-content/60 font-medium">{item.country}</p>
          {/if}
          {#if item.excerpt}
            <p class="text-sm text-base-content/80 mt-2 line-clamp-2 sm:line-clamp-3">{item.excerpt}</p>
          {/if}
        </div>
      </div>

    {:else if type === 'news'}
      <a href={normalizeSlug(item.slug, 'news')} class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow border border-base-200 flex-row overflow-hidden">
        {#if item.image}
          <figure class="w-1/3 sm:w-1/4 h-full min-h-[140px] bg-base-200">
            <Image 
              src={`http://127.0.0.1:8090/api/files/news/${item.id}/${item.image}`} 
              alt={item.heading} 
              class="w-full h-full"
              objectFit="cover"
            />
          </figure>
        {/if}
        <div class="card-body flex-1 justify-center">
          {#if item.created}
            <span class="text-xs text-base-content/60 mb-1 font-medium">{formatDate(item.created)}</span>
          {/if}
          <h3 class="card-title text-lg sm:text-xl text-primary">{item.heading}</h3>
          {#if item.excerpt}
            <p class="text-sm text-base-content/80 line-clamp-2 sm:line-clamp-3">{item.excerpt}</p>
          {/if}
        </div>
      </a>
    {/if}

  {/each}
</div>