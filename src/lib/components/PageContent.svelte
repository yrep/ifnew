<script>
  let { html = '', class: className = '' } = $props();
</script>

<div class="prose prose-invert max-w-none {className}">
  {@html html}
</div>

<style>
  .prose :global(h1),
  .prose :global(h2),
  .prose :global(h3),
  .prose :global(h4),
  .prose :global(h5),
  .prose :global(h6) {
    color: var(--fallback-s, oklch(var(--s) / 1)) !important;
  }
</style>