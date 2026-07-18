<script>
  import Image from '$lib/components/Common/Image.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  
  let { items, type = 'default' } = $props();
</script>

<div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
  {#each items as item (item.id)}
    
    {#if type === 'partners'}
      <div class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow">
        <div class="card-body">
          <div class="flex items-start gap-4">
            {#if item.logo}
              <figure class="w-20 h-20 flex-shrink-0 bg-base-200 rounded-box overflow-hidden">
                <Image 
                  src={`http://127.0.0.1:8090/api/files/section_items_partners/${item.id}/${item.logo}`} 
                  alt={item.name} 
                  class="w-full h-full"
                  objectFit="contain"
                />
              </figure>
            {/if}
            <div class="flex-1">
              <h3 class="card-title text-lg">{item.name}</h3>
              {#if item.country}
                <p class="text-sm text-base-content/60">{item.country}</p>
              {/if}
            </div>
          </div>
          {#if item.excerpt}
            <p class="mt-3 text-sm text-base-content/80">{item.excerpt}</p>
          {/if}
        </div>
      </div>

    {:else if type === 'products'}
      <a href={normalizeSlug(item.slug, 'product')} class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow">
        <figure class="aspect-[4/3] w-full bg-base-200">
          <Image 
            src={item.image ? `http://127.0.0.1:8090/api/files/products/${item.id}/${item.image}` : ''} 
            alt={item.name} 
            class="w-full h-full"
            objectFit="cover"
          />
        </figure>
        <div class="card-body">
          <h3 class="card-title text-lg">{item.name}</h3>
          {#if item.excerpt}
            <p class="text-sm text-base-content/70 line-clamp-2">{item.excerpt}</p>
          {/if}
        </div>
      </a>

    {:else if type === 'news'}
      <a href={normalizeSlug(item.slug, 'news')} class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow">
        <figure class="aspect-[4/3] w-full bg-base-200">
          <Image 
            src={item.image ? `http://127.0.0.1:8090/api/files/news/${item.id}/${item.image}` : ''} 
            alt={item.heading} 
            class="w-full h-full"
            objectFit="cover"
          />
        </figure>
        <div class="card-body">
          <h3 class="card-title text-lg">{item.heading}</h3>
          {#if item.excerpt}
            <p class="text-sm text-base-content/70 line-clamp-2">{item.excerpt}</p>
          {/if}
        </div>
      </a>

    {:else}
      <div class="card bg-base-100 shadow-sm">
        <div class="card-body">
          <h3 class="card-title">{item.name || item.title || 'Без названия'}</h3>
          {#if item.excerpt || item.description}
            <p class="text-sm text-base-content/70">{item.excerpt || item.description}</p>
          {/if}
        </div>
      </div>
    {/if}

  {/each}
</div>