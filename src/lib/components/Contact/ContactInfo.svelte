<!-- src/lib/components/Contact/ContactInfo.svelte -->
<script>
  import { formatPhone } from "$lib/common/strings.js";

  let { contacts } = $props();
</script>

<div class="rounded-box border border-base-200 bg-base-100 p-6">
  <h2 class="mb-4 text-xl font-semibold">Как с нами связаться</h2>
  <dl class="flex flex-col gap-4">
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Адрес</dt>
      <dd class="mt-1">{contacts.address}</dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Телефон</dt>
      <dd class="mt-1">
        <a class="link link-hover" href={`tel:${contacts.phone}`}>{formatPhone(contacts.phone)}</a>
      </dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Email</dt>
      <dd class="mt-1">
        <a class="link link-hover" href={`mailto:${contacts.email}`}>{contacts.email}</a>
      </dd>
    </div>
    <div>
      <dt class="text-xs uppercase tracking-wider opacity-60">Режим работы</dt>
      <dd class="mt-1">{contacts.workHours}</dd>
    </div>
  </dl>
</div>

