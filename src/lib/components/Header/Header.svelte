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
  
  <!-- mobile  -->
  <div class="md:hidden bg-white border-b border-base-200">
    <div class="max-w-7xl mx-auto px-4 flex h-fit justify-between items-end gap-4 py-3">
      <div class="flex flex-col leading-none">
        <LogoUpper class="h-8 w-auto" />
        <LogoLower class="h-4 w-auto" />
      </div>
      <NavMenu />
    </div>
  </div>
  
  <!-- desktop -->
  <div class="hidden md:block">
    
    <div class="bg-white w-full">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-[200px_1fr] h-fit">
        <div class="bg-white flex items-end">
          <LogoUpper class="h-16 w-auto block" />
        </div>
        <div class="flex items-center justify-end">
          <NavMenu />
        </div>
      </div>
    </div>

    <div class="bg-accent w-full">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 grid grid-cols-[200px_1fr] h-fit">
        <div class="bg-white flex items-start">
          <LogoLower class="h-8 w-auto block" />
        </div>
        <div class="flex items-center justify-end">
          <ContactBar />
        </div>
      </div>
    </div>

  </div>
</header>