<!-- src/lib/components/PageContent.svelte -->
<script>
  let { html = '', class: className = '' } = $props();
</script>

<div class="page-content {className}">
  {@html html}
</div>

<style>
  .page-content {
    font-family: 'Inter', sans-serif;
    font-size: 1.05rem;
    line-height: 1.7;
    font-weight: 200;
    color: var(--fallback-bc, oklch(var(--bc) / 0.8));
  }

  .page-content :global(h1) { 
    font-size: 2.25rem; 
    font-weight: 400;
    letter-spacing: -0.02em;
    margin-top: 2rem; 
    margin-bottom: 1rem; 
    line-height: 1.2; 
    color: var(--fallback-bc, oklch(var(--bc) / 1));
  }

  .page-content :global(h2) { 
    font-size: 1.75rem; 
    font-weight: 400;
    letter-spacing: -0.015em;
    margin-top: 2rem; 
    margin-bottom: 0.875rem; 
    line-height: 1.3; 
    color: var(--fallback-bc, oklch(var(--bc) / 1));
  }

  .page-content :global(h3) { 
    font-size: 1.35rem; 
    font-weight: 400;
    letter-spacing: -0.01em;
    margin-top: 1.5rem; 
    margin-bottom: 0.75rem; 
    line-height: 1.4; 
    color: var(--fallback-bc, oklch(var(--bc) / 1));
  }

  .page-content :global(p) { 
    margin-top: 0; 
    margin-bottom: 1.25rem; 
  }

 .page-content :global(ul),
  .page-content :global(ol) { 
    margin-top: 0; 
    margin-bottom: 1.25rem; 
    padding-left: 1.5rem; 
    list-style-position: outside;
  }
  
  .page-content :global(ul) { 
    list-style-type: disc; 
  }
  
  .page-content :global(ol) { 
    list-style-type: decimal; 
  }
  
  /* Маркеры в цвет текста темы */
  .page-content :global(ul li)::marker,
  .page-content :global(ol li)::marker {
    color: var(--fallback-p, oklch(var(--p) / 0.7));
    font-weight: 400;
  }
  
  .page-content :global(li) { 
    margin-bottom: 0.5rem; 
    font-weight: 200;
    padding-left: 0.25rem;
  }

  .page-content :global(a) {
    color: var(--fallback-p, oklch(var(--p) / 1));
    text-decoration: none;
    border-bottom: 1px solid transparent;
    transition: all 0.2s ease;
    font-weight: 200;
    text-align: justify;
    text-justify: inter-word;
    hyphens: auto;
  }
  .page-content :global(a:hover) { 
    border-bottom-color: currentColor;
  }

  .page-content :global(blockquote) {
    margin: 1.5rem 0;
    padding: 1.25rem 1.5rem;
    border-left: 2px solid var(--fallback-p, oklch(var(--p) / 1));
    background-color: var(--fallback-b2, oklch(var(--b2) / 0.3));
    border-radius: 0 0.5rem 0.5rem 0;
    font-style: italic;
    font-weight: 200;
  }

  .page-content :global(img) {
    max-width: 100%;
    height: auto;
    border-radius: 0.5rem;
    margin: 1.5rem 0;
  }
</style>