<!-- src/lib/components/Sections/CustomProductsGrid.svelte -->
<script>
  import { onMount } from 'svelte';
  import ProductCard from './Cards/ProductCard.svelte';
  import CategoryCard from './Cards/CategoryCard.svelte';
  import { sortProductsByOrder } from '$lib/common/productSort.js';
  import { computeProductsGridRows } from '$lib/common/productsGridParser.js';

  let { items = [], config = null } = $props();

  const GAP = 16;
  const MIN_CARD_W = 180;
  const DESKTOP_MIN = 1024;

  const entries = $derived.by(() => {
    const products = [];
    const categories = new Map();

    for (const item of items) {
      if (item.category) {
        const name = item.category.name || 'Unknown';
        if (!categories.has(name)) categories.set(name, { ...item.category, items: [] });
        categories.get(name).items.push(item);
      } else {
        products.push(item);
      }
    }

    const cats = [...categories.entries()]
      .map(([name, group]) => ({ name, ...group, items: sortProductsByOrder(group.items) }))
      .sort((a, b) => (a.order || 0) - (b.order || 0));

    return [
      ...sortProductsByOrder(products).map((item) => ({ kind: 'product', item })),
      ...cats.map((category) => ({ kind: 'category', category })),
    ];
  });

  const rowSizes = $derived(config ? computeProductsGridRows(entries.length, config) : []);
  const maxPerRow = $derived(rowSizes.length ? Math.max(...rowSizes) : 1);
  const cardWidth = $derived(`calc((100% - ${(maxPerRow - 1) * GAP}px) / ${maxPerRow})`);

  const rows = $derived.by(() => {
    const out = [];
    let i = 0;
    for (const size of rowSizes) {
      out.push(entries.slice(i, i + size));
      i += size;
    }
    if (i < entries.length) out.push(entries.slice(i));
    return out;
  });

  let containerEl;
  let containerWidth = $state(0);

  onMount(() => {
    if (!containerEl) return;
    const update = () => {
      containerWidth = containerEl.getBoundingClientRect().width;
    };
    update();
    const ro = new ResizeObserver(update);
    ro.observe(containerEl);
    return () => ro.disconnect();
  });

  const layout = $derived.by(() => {
    if (containerWidth === 0 || containerWidth < DESKTOP_MIN) return 'grid';
    const needed = maxPerRow * MIN_CARD_W + (maxPerRow - 1) * GAP;
    return containerWidth < needed ? 'single' : 'custom';
  });

  const keyOf = (entry) =>
    entry.kind === 'product' ? `p-${entry.item.id}` : `c-${entry.category.name}`;
</script>

<div bind:this={containerEl} class="w-full">
  {#if layout === 'custom'}
    <div class="flex flex-col gap-4 w-full">
      {#each rows as row, i (i)}
        <div class="flex justify-center gap-4 w-full">
          {#each row as entry (keyOf(entry))}
            <div class="flex-shrink-0" style="width: {cardWidth}; max-width: 100%;">
              {#if entry.kind === 'product'}
                <ProductCard item={entry.item} />
              {:else}
                <CategoryCard category={entry.category} />
              {/if}
            </div>
          {/each}
        </div>
      {/each}
    </div>

  {:else if layout === 'single'}
    <div class="grid grid-cols-1 gap-4 auto-rows-fr">
      {#each entries as entry (keyOf(entry))}
        {#if entry.kind === 'product'}
          <ProductCard item={entry.item} />
        {:else}
          <CategoryCard category={entry.category} />
        {/if}
      {/each}
    </div>

  {:else}
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 auto-rows-fr">
      {#each entries as entry (keyOf(entry))}
        {#if entry.kind === 'product'}
          <ProductCard item={entry.item} />
        {:else}
          <CategoryCard category={entry.category} />
        {/if}
      {/each}
    </div>
  {/if}
</div>