<!-- src/lib/components/Header/Header.svelte -->
<script>
  import Logo from "$lib/components/Common/Logo.svelte";
  import NavMenu from "./NavMenu.svelte";
  import ThemeSwitch from "./ThemeSwitch.svelte";
  import LangSwitch from "./LangSwitch.svelte";
</script>

<header class="sticky top-0 z-40 border-b border-base-200 bg-base-100/90">
  <div class="container mx-auto flex h-16 items-center justify-between gap-4 px-4">
    <Logo class="w-24 md:w-40" />
    
    <NavMenu>
      {#snippet children()}
        <ThemeSwitch />
      {/snippet}
    </NavMenu>
    
    <div class="hidden md:flex items-center gap-2">
      <LangSwitch />
      <ThemeSwitch />
    </div>
  </div>
</header>