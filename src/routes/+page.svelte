<!-- src/routes/+page.svelte -->
<script>
  import PageBuilder from '$lib/components/PageBuilder.svelte';
  let { data } = $props();
</script>

<PageBuilder data={data.pageData} />