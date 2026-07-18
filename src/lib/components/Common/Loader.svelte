<!-- src/lib/components/Common/Loader.svelte -->
<script>
  let { size = 'loading-md', color = 'text-primary' } = $props();
</script>

<span class={`loading loading-spinner {size} {color}`}></span>