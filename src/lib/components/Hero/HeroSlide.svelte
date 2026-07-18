<!-- src/lib/components/Hero/HeroSlide.svelte -->
<script>
  let { slide } = $props();
</script>

<div class="relative h-full w-full">
  <img
    src={slide.image}
    alt={slide.title}
    class="absolute inset-0 h-full w-full object-cover"
    loading="lazy"
  />
  <div class="absolute inset-0 bg-gradient-to-t from-base-100/90 via-base-100/40 to-base-100/10"></div>
  <div class="relative flex h-full flex-col justify-end p-6 sm:p-10">
    <h2 class="text-2xl font-bold sm:text-4xl lg:text-5xl">{slide.title}</h2>
    <p class="mt-2 max-w-xl text-base opacity-80 sm:text-lg">{slide.subtitle}</p>
    {#if slide.cta}
      <div class="mt-4">
        <a href={slide.cta.href} class="btn btn-primary">{slide.cta.label}</a>
      </div>
    {/if}
  </div>
</div>

