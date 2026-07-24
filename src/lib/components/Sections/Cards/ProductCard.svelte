<script>
  import Image from '$lib/components/Common/Image.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';

  let { item } = $props();
</script>

<a
  href={normalizeSlug(item.slug, 'product')}
  class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow border border-base-200 overflow-hidden group h-full flex flex-col"
>
  {#if item.image}
    <figure class="aspect-[4/3] bg-base-200 overflow-hidden flex-shrink-0">
      <Image
        src={item.image}
        alt={item.image_alt || item.name || item.heading}
        class="w-full h-full group-hover:scale-105 transition-transform duration-300"
        objectFit="cover"
      />
    </figure>
  {:else}
    <div class="aspect-[4/3] bg-base-200 flex items-center justify-center flex-shrink-0">
      <span class="text-base-content/30 text-3xl">📦</span>
    </div>
  {/if}
  <div class="card-body p-3 flex-1 flex flex-col">
    <h3 class="card-title text-sm text-primary group-hover:text-accent transition-colors line-clamp-2 min-h-[2.5rem]">
      {item.name || item.heading || item.title}
    </h3>
    {#if item.excerpt}
      <p class="text-xs text-base-content/70 line-clamp-2 mt-1 flex-1">{item.excerpt}</p>
    {/if}
  </div>
</a>