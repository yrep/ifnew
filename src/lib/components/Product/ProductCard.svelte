<!-- src/lib/components/Product/ProductCard.svelte -->
<script>
  import Image from '$lib/components/Common/Image.svelte';
  let { product } = $props();
</script>

<a href={product.slug} class="card bg-base-100 shadow-sm hover:shadow-md transition-shadow">
  <figure class="aspect-[4/3] w-full bg-base-200">
    <Image 
      src={product.image || ''} 
      alt={product.title} 
      class="w-full h-full"
      objectFit="cover"
    />
  </figure>
  <div class="card-body">
    <h3 class="card-title text-lg">{product.title}</h3>
    {#if product.excerpt}
      <p class="text-sm text-base-content/70 line-clamp-2">{product.excerpt}</p>
    {/if}
  </div>
</a>