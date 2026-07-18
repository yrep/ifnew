<!-- src/lib/components/Footer/NavFooter.svelte -->
<script>
  let { groups = [] } = $props();
</script>

<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
  {#each groups as group}
    <ul class="flex flex-col gap-1">
      {#each group as item}
        <li>
          <a href={item.slug} class="link link-hover transition-colors hover:text-primary">
            {item.title}
          </a>
        </li>
      {/each}
    </ul>
  {/each}
</div>