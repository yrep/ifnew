<!-- src/routes/+layout.svelte -->
<script>
  import '../app.css';
  import Header from "$lib/components/Header/Header.svelte";
  import Footer from "$lib/components/Footer/Footer.svelte";
  import { theme, applyTheme } from "$lib/stores/theme.svelte.js";
  import { onMount } from 'svelte';
  import { loadContacts } from "$lib/stores/contacts.svelte.js";

  let { children } = $props();

  onMount(() => {
    loadContacts();
  });

  $effect(() => {
    applyTheme(theme.current);
  });
</script>

<div class="flex min-h-screen flex-col bg-base-100 text-base-content">
  <Header />
  <main class="flex-1">
    {@render children()}
  </main>
  <Footer />
</div>