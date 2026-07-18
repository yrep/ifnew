<script>
  import CardList from './Cards/CardList.svelte';
  
  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
</script>

<section class="py-8 w-full">
  {#if sectionDef.show_heading_excerpt}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{sectionDef.heading}</h2>
      {#if sectionDef.excerpt}
        <p class="mt-2 text-base-content/70">{sectionDef.excerpt}</p>
      {/if}
    </div>
  {/if}

  <CardList items={section.items || []} type="partners" />
</section>