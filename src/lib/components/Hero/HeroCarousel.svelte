<!-- src/lib/components/Hero/HeroCarousel.svelte -->
<script>
  import HeroSlide from "./HeroSlide.svelte";

  let { slides = [] } = $props();
  let index = $state(0);
  let timer;

  const count = $derived(slides.length);

  function next() {
    if (count === 0) return;
    index = (index + 1) % count;
  }
  function prev() {
    if (count === 0) return;
    index = (index - 1 + count) % count;
  }
  function go(i) {
    index = i;
  }

  $effect(() => {
    if (count <= 1) return;
    timer = setInterval(next, 6000);
    return () => clearInterval(timer);
  });
</script>

{#if count > 0}
  <section class="relative overflow-hidden rounded-box">
    <div class="relative aspect-[16/7] w-full sm:aspect-[16/6] lg:aspect-[16/5]">
      {#each slides as slide, i (slide.id)}
        <div
          class="absolute inset-0 transition-opacity duration-700"
          class:opacity-100={i === index}
          class:opacity-0={i !== index}
          aria-hidden={i !== index}
        >
          <HeroSlide {slide} />
        </div>
      {/each}
    </div>

    {#if count > 1}
      <div class="absolute inset-x-0 bottom-4 flex items-center justify-center gap-2">
        {#each slides as _, i}
          <button
            type="button"
            class="btn btn-xs btn-circle"
            class:btn-primary={i === index}
            class:btn-ghost={i !== index}
            aria-label="Слайд {i + 1}"
            onclick={() => go(i)}
          ></button>
        {/each}
      </div>

      <button
        type="button"
        class="btn btn-circle btn-sm absolute left-2 top-1/2 -translate-y-1/2"
        aria-label="Предыдущий слайд"
        onclick={prev}
      >‹</button>
      <button
        type="button"
        class="btn btn-circle btn-sm absolute right-2 top-1/2 -translate-y-1/2"
        aria-label="Следующий слайд"
        onclick={next}
      >›</button>
    {/if}
  </section>
{/if}

