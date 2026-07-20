<script>
  import { sectionComponents } from '$lib/common/pageConfig.js';
  import Image from '$lib/components/Common/Image.svelte';
  import PageContent from '$lib/components/PageContent.svelte';
  import Breadcrumbs from '$lib/components/Breadcrumbs.svelte';
  
  let { data } = $props();
</script>

<main class="w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12 py-8">

  <Breadcrumbs currentTitle={data.page.title} />

  {#each data.beforeContent as section (section.id)}
    {#if section.expand?.section?.type}
      {@const type = section.expand.section.type}
      {@const Comp = sectionComponents[type]}
      {#if Comp}
        <Comp section={section} pageSlug={data.page.slug || '/'} />
      {/if}
    {/if}
  {/each}

  <div class="w-full">
    {#if data.page.image}
      <div class="mb-8 aspect-[21/9] w-full overflow-hidden rounded-box">
        <Image src={data.page.image} alt={data.page.alt || data.page.title} objectFit="cover" />
      </div>
    {/if}
    
    <h1 class="text-2xl sm:text-4xl md:text-4xl font-bold mb-6 break-words hyphens-auto text-secondary">
      {data.page.title}
    </h1>
    {#if data.page.display_date}
      <div class="mb-6">
        <span class="badge badge-secondary">
          {new Date(data.page.display_date).toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' })}
        </span>
      </div>
    {/if}
  </div>

  {#each data.betweenContent as section (section.id)}
    {#if section.expand?.section?.type}
      {@const type = section.expand.section.type}
      {@const Comp = sectionComponents[type]}
      {#if Comp}
        <Comp section={section} pageSlug={data.page.slug || '/'} />
      {/if}
    {/if}
  {/each}

  <div class="w-full">
    <PageContent html={data.page.html} />
  </div>

  {#each data.afterContent as section (section.id)}
    {#if section.expand?.section?.type}
      {@const type = section.expand.section.type}
      {@const Comp = sectionComponents[type]}
      {#if Comp}
        <Comp section={section} pageSlug={data.page.slug || '/'} />
      {/if}
    {/if}
  {/each}

</main>