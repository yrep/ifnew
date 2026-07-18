// src/lib/stores/settings.svelte.js
import { config } from "$lib/common/config.js";

export const settings = $state({
  entities: config.settings.entities,
  sections: config.settings.sections,
  menu: config.settings.menu,
});
