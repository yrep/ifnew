<!-- src/routes/[...slug]/+page.svelte -->
<script>
  import PageBuilder from '$lib/components/PageBuilder.svelte';
  import { dlog } from '$lib/common/dlog.js';
  let { data } = $props();
  dlog('Page data loaded:', data);
</script>

<PageBuilder data={data.pageData} />