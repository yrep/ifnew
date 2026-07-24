<script>
  import { onMount } from 'svelte';
  import LogoUpper from "$lib/components/Common/LogoUpper.svelte";
  import LogoLower from "$lib/components/Common/LogoLower.svelte";
  import NavMenu from "./NavMenu.svelte";
  import ContactBar from "./ContactBar.svelte";

  let isScrolled = $state(false);

  onMount(() => {
    const handleScroll = () => {
      isScrolled = window.scrollY > 0;
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  });
</script>

<header class="sticky top-0 z-40 shadow-sm transition-all duration-200 {isScrolled ? 'bg-white/80' : ''}">
  <!-- mob -->
  <div class="md:hidden bg-white border-b border-base-200">
    <div class="max-w-7xl mx-auto px-4 flex h-20 justify-between items-end gap-4 pb-3">
      <div class="flex flex-col leading-none">
        <LogoUpper class="h-8 w-auto" />
        <LogoLower class="h-4 w-auto" />
      </div>
      <NavMenu />
    </div>
  </div>
  
  <!-- desktop -->
  <div class="hidden md:grid md:grid-cols-[0.5rem_auto_0.5rem_1fr_1fr_0.5rem] md:grid-rows-[80px_32px] max-w-7xl mx-auto h-fit">
    
    <!-- white -->
    <div class="col-span-1 bg-white h-20"></div>
    <div class="col-span-1 bg-white h-20 flex items-end justify-center pb-0">
      <LogoUpper class="h-16 w-auto" />
    </div>
    <div class="col-span-1 bg-white h-20"></div>
    <div class="col-span-2 bg-white h-20 flex items-center justify-end px-4">
      <NavMenu />
    </div>
    <div class="col-span-1 bg-white h-20"></div>
    
    <!-- green -->
    <div class="col-span-1 bg-accent h-8"></div>
    <div class="col-span-1 bg-white h-8 flex items-start justify-center pt-0">
      <LogoLower class="h-8 w-auto" />
    </div>
    <div class="col-span-1 bg-accent h-8"></div>
    <div class="col-span-1 bg-accent h-8"></div>
    <div class="col-span-1 bg-accent h-8 flex items-center justify-end px-4">
      <ContactBar />
    </div>
    <div class="col-span-1 bg-accent h-8"></div>
    
  </div>
</header>