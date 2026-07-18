<script>
  let { src = '', alt = '', class: className = '', objectFit = 'cover' } = $props();
  
  let hasError = $state(false);

  $effect(() => {
    hasError = src === '';
  });

  function handleError() {
    hasError = true;
  }
</script>

{#if hasError || !src}
  <div class={`flex items-center justify-center bg-base-300 text-base-content/20 ${className}`}>
    <svg xmlns="http://www.w3.org/2000/svg" class="h-1/3 w-1/3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
    </svg>
  </div>
{:else}
  <img 
    {src} 
    {alt} 
    class={`w-full h-full ${className}`} 
    style="object-fit: {objectFit};" 
    onerror={handleError} 
  />
{/if}