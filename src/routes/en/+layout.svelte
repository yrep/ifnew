<!-- src/routes/en/+layout.svelte -->
<script>
  let { children } = $props();
</script>

<div class="flex min-h-screen items-center justify-center px-4 bg-base-100">
  <div class="alert alert-warning max-w-md shadow-lg">
    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M4.93 19h14.14c1.34 0 2.17-1.45 1.5-2.62L13.5 4.38c-.67-1.17-2.33-1.17-3 0L3.43 16.38C2.76 17.55 3.59 19 4.93 19z" />
    </svg>
    <span class="text-lg font-semibold">Sorry, English version not available yet</span>
  </div>
</div>

{@render children()}