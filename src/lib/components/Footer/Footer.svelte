<!-- src/lib/components/Footer/Footer.svelte -->
<script>
  import NavFooter from "./NavFooter.svelte";
  import ContactsFooter from "./ContactsFooter.svelte";
  import Copyright from "./Copyright.svelte";
  import { config } from "$lib/common/config.js";

  const groups = config.settings.menu.footer.groups;
</script>

<footer class="mt-auto border-t border-base-200 bg-primary text-primary-content">
  <div class="container mx-auto grid grid-cols-1 gap-8 px-4 py-10 md:grid-cols-3">
    <div class="md:col-span-2">
      <NavFooter {groups} />
    </div>
    <ContactsFooter />
  </div>
  <Copyright />
</footer>