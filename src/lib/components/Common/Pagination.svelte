<!-- src/lib/components/Common/Pagination.svelte -->
<script>
  import { goto } from '$app/navigation';
  import { page } from '$app/state';

  let { currentPage, totalPages, basePath } = $props();

  function setPage(n) {
    goto(`${basePath}?page=${n}`, { replaceState: true, keepFocus: true });
  }
</script>

{#if totalPages > 1}
  <div class="mt-8 flex justify-center">
    <div class="join">
      <button class="join-item btn" disabled={currentPage <= 1} onclick={() => setPage(currentPage - 1)}>«</button>
      
      {#each Array(totalPages) as _, i}
        <button 
          class="join-item btn" 
          class:btn-active={i + 1 === currentPage}
          onclick={() => setPage(i + 1)}
        >
          {i + 1}
        </button>
      {/each}
      
      <button class="join-item btn" disabled={currentPage >= totalPages} onclick={() => setPage(currentPage + 1)}>»</button>
    </div>
  </div>
{/if}