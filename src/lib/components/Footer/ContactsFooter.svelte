<script>
  import { formatPhone } from "$lib/common/strings.js";
  let { contacts } = $props();
</script>

<div>
  <h3 class="mb-3 text-sm font-semibold uppercase tracking-wider opacity-70">Контакты</h3>
  <address class="flex flex-col gap-2 not-italic">
    <span>{contacts.address}</span>
    <a class="link link-hover" href={`tel:${contacts.phone}`}>{formatPhone(contacts.phone)}</a>
    <a class="link link-hover" href={`mailto:${contacts.email}`}>{contacts.email}</a>
  </address>
</div>