<script>
  import Image from '$lib/components/Common/Image.svelte';
  import { normalizeSlug } from '$lib/common/slugChecker.js';
  import { getFullFileUrl } from '$lib/common/fileUtils.js';

  let { category } = $props();

  const imageUrl = $derived(
    category?.image 
      ? getFullFileUrl({ ...category, collectionName: 'product_categories' }, 'image') 
      : null
  );
</script>

<a
  href={normalizeSlug(category?.slug || '', 'category')}
  class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow border border-base-200 overflow-hidden group h-full flex flex-col"
>
  {#if imageUrl}
    <figure class="aspect-[4/3] bg-base-200 overflow-hidden flex-shrink-0">
      <Image
        src={imageUrl}
        alt={category?.image_alt || category?.name || 'Категория'}
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
      {category?.name || 'Категория'}
    </h3>
    {#if category?.excerpt}
      <p class="text-xs text-base-content/70 line-clamp-2 mt-1 flex-1">{category.excerpt}</p>
    {/if}
  </div>
</a>