<!-- src/lib/components/Footer/ContactsFooter.svelte -->
<script>
  import { formatPhone } from "$lib/common/strings.js";

  const address = "г. Москва, ул. Промышленная, 10";
  const phone = "+74951234567";
  const email = "info@ifnew.ru";
</script>

<div>
  <h3 class="mb-3 text-sm font-semibold uppercase tracking-wider opacity-70">Контакты</h3>
  <address class="flex flex-col gap-2 not-italic">
    <span>{address}</span>
    <a class="link link-hover" href={`tel:${phone}`}>{formatPhone(phone)}</a>
    <a class="link link-hover" href={`mailto:${email}`}>{email}</a>
  </address>
</div>

