<!-- src/lib/components/Sections/CustomSectionBuilder.svelte -->
<script>
  import { t } from '$lib/common/translations.js';

  let { section } = $props();
  
  const data = $derived(section.parsedData || {});
  const sectionDef = $derived(section.expand?.section || {});

  function formatLabel(key) {
    return key
      .split('_')
      .map((word, i) => i === 0 ? word.charAt(0).toUpperCase() + word.slice(1) : word)
      .join(' ');
  }
</script>

<section class="py-8">
  {#if sectionDef.show_heading_excerpt}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{sectionDef.heading}</h2>
      {#if sectionDef.excerpt}
        <p class="mt-2 text-base-content/70">{sectionDef.excerpt}</p>
      {/if}
    </div>
  {/if}

  <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
    {#each Object.entries(data) as [key, value]}
      <div class="rounded-box bg-base-100 p-4 shadow-sm border border-base-200">
        <h3 class="mb-1 text-xs font-semibold uppercase tracking-wider opacity-60">
          {t(`section_fields.${key}`, formatLabel(key))}
        </h3>
        <p class="text-base font-medium break-words">{value}</p>
      </div>
    {/each}
  </div>
</section>