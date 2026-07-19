<!-- src/lib/components/Sections/HeroSection.svelte -->
<script>
  import Image from '$lib/components/Common/Image.svelte';
  import { dlog } from '$lib/common/dlog.js';

  let { section } = $props();
  const items = $derived(section.items || []);
  
  dlog(section, "Section HERO");

  let activeSlide = $state(0);
  let intervalId = $state(null);
  let touchStartX = $state(0);
  let touchStartY = $state(0);

  function nextSlide() {
    activeSlide = (activeSlide + 1) % items.length;
  }

  function prevSlide() {
    activeSlide = (activeSlide - 1 + items.length) % items.length;
  }

  function startAutoPlay() {
    if (items.length > 1 && !intervalId) {
      intervalId = setInterval(nextSlide, 2000);
    }
  }

  function stopAutoPlay() {
    if (intervalId) {
      clearInterval(intervalId);
      intervalId = null;
    }
  }

  function handleTouchStart(e) {
    touchStartX = e.changedTouches[0].screenX;
    touchStartY = e.changedTouches[0].screenY;
    stopAutoPlay();
  }

  function handleTouchEnd(e) {
    const deltaX = e.changedTouches[0].screenX - touchStartX;
    const deltaY = e.changedTouches[0].screenY - touchStartY;
    if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 50) {
      if (deltaX > 0) {
        prevSlide();
      } else {
        nextSlide();
      }
    }
    startAutoPlay();
  }

  $effect(() => {
    startAutoPlay();
    return () => stopAutoPlay();
  });
</script>

{#if items.length > 0}
  <div 
    role="region"
    aria-label="Hero Carousel"
    class="relative w-full aspect-[16/7] min-h-[400px] rounded-box bg-base-200 mb-8 overflow-hidden touch-pan-y"
    onmouseenter={stopAutoPlay}
    onmouseleave={startAutoPlay}
    ontouchstart={handleTouchStart}
    ontouchend={handleTouchEnd}
  >
    <div class="flex h-full transition-transform duration-500 ease-in-out" style="transform: translateX(-{activeSlide * 100}%)">
      {#each items as item (item.id)}
        <div class="w-full flex-shrink-0 relative h-full">
          <Image
            src={item.image || ''}
            alt={item.image_alt || item.title}
            class="w-full h-full"
            objectFit="cover"
          />
          <div class="absolute inset-0 bg-gradient-to-t from-base-100 via-base-100/40 to-transparent"></div>
          
          <div class="absolute bottom-0 left-0 p-6 sm:p-12 w-full">
            <h2 class="text-3xl font-bold sm:text-5xl text-base-content drop-shadow-md">{item.title}</h2>
            {#if item.excerpt}
              <p class="mt-4 max-w-2xl text-lg sm:text-xl text-base-content/90 drop-shadow-sm">{item.excerpt}</p>
            {/if}
            {#if item.cta_link}
              <a href={item.cta_link} class="btn btn-primary mt-6 shadow-lg">
                {item.cta_btn_text || 'Подробнее'}
              </a>
            {/if}
          </div>
        </div>
      {/each}
    </div>

    {#if items.length > 1}
      <div class="absolute hidden sm:flex justify-between w-full top-1/2 -translate-y-1/2 px-4">
        <button class="btn btn-circle btn-ghost bg-black/20 text-white hover:bg-black/40" onclick={prevSlide}>❮</button>
        <button class="btn btn-circle btn-ghost bg-black/20 text-white hover:bg-black/40" onclick={nextSlide}>❯</button>
      </div>
    {/if}
  </div>
{:else}
  <div class="p-10 text-center opacity-50 bg-base-200 rounded-box mb-8">Hero секция пуста</div>
{/if}