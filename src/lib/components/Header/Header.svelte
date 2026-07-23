<script>
  import Logo from "$lib/components/Common/Logo.svelte";
  import NavMenu from "./NavMenu.svelte";
  import ContactBar from "./ContactBar.svelte";
</script>

<header class="sticky top-0 z-40 shadow-sm">
  <div class="md:hidden bg-white border-b border-base-200 relative">
    <div class="max-w-7xl mx-auto px-4 flex h-20 justify-between items-end gap-4 pb-3">
      <Logo class="h-12 w-auto text-base-content" />
      <NavMenu />
    </div>
  </div>
  
  <div class="hidden md:block relative">
    <div class="bg-white h-20">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex justify-end items-center h-full">
        <NavMenu />
      </div>
    </div>
    
    <div class="bg-accent h-10">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex justify-end items-center h-full">
        <ContactBar />
      </div>
    </div>
    
    <div class="absolute -bottom-2 left-4 sm:left-6 lg:left-8 z-10">
      <Logo class="h-[120px] w-auto text-white" />
    </div>
  </div>
</header>