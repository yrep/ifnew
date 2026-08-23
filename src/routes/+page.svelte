<!-- src/routes/+page.svelte -->
<script>
  import PageBuilder from '$lib/components/PageBuilder.svelte';
  import { dlog } from '$lib/common/dlog.js';
  
  let { data } = $props();
  
  dlog('Main Page data loaded:', data);

  const page = data.pageData?.page || {};
  const raw = page.raw || {};
  
  const title = raw.meta_title || page.title || 'IFNEW';
  const description = raw.meta_description || '';
  const keywords = raw.meta_keywords || '';

  const ogTitle = 'OOO Интерфид — корма и кормовые добавки';
  const ogDescription = 'Высококачественные корма и кормовые добавки для сельскохозяйственных животных от компании Интерфид: широкий ассортимент, оптовые продажи, доставка.';
  const ogImage = 'https://interfeed.ru/svg/interfeed_logo.svg';
  const ogUrl = 'https://interfeed.ru/';


</script>

<svelte:head>
  <title>{title}</title>
  
  {#if description}
    <meta name="description" content={description} />
    <meta property="og:description" content={description} />
  {/if}
  
  {#if keywords}
    <meta name="keywords" content={keywords} />
  {/if}
  
  {#if page.image}
    <meta property="og:image" content={page.image} />
  {/if}

  <meta property="og:title" content={ogTitle} />
  <meta property="og:description" content={ogDescription} />
  <meta property="og:type" content="website" />
  <meta property="og:url" content={ogUrl} />
  <meta property="og:image" content={ogImage} />
  <meta property="og:image:alt" content="Логотип Интерфид" />
  <meta property="og:site_name" content="Интерфид" />

</svelte:head>

<PageBuilder data={data.pageData} />