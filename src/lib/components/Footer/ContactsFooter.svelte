<!-- src/lib/components/Footer/ContactsFooter.svelte -->
<script>
  import { onMount } from 'svelte';
  import { formatPhone } from "$lib/common/strings.js";
  import { contactsStore, loadContacts } from "$lib/stores/contacts.svelte.js";

  onMount(() => {
    if (!contactsStore.loaded) {
      loadContacts();
    }
  });
</script>

{#if contactsStore.loaded}
  <div>
    <h3 class="mb-3 text-sm font-semibold uppercase tracking-wider opacity-70">Контакты</h3>
    <address class="flex flex-col gap-2 not-italic">
      <span>{contactsStore.address}</span>
      <a class="link link-hover" href={`tel:${contactsStore.phone}`}>{formatPhone(contactsStore.phone)}</a>
      <a class="link link-hover" href={`mailto:${contactsStore.email}`}>{contactsStore.email}</a>
    </address>
  </div>
{/if}