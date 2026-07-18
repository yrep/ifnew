<!-- src/lib/components/Footer/Copyright.svelte -->
<script>
  import { currentYear } from "$lib/common/strings.js";

  const startYear = 2013;
  const endYear = currentYear();
  const label = startYear === endYear ? `${startYear}` : `${startYear}–${endYear}`;
</script>

<div class="border-t border-base-300 py-4 text-center text-sm opacity-70">
  © {label} Интерфид. Все права защищены.
</div>

