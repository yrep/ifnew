import { fetchSetting } from '$lib/frontend/api/settings.js';
import { parseProductsGridConfig } from '$lib/common/productsGridParser.js';

export const productsGridConfig = $state({ value: null, loaded: false });

let inflight = null;

export function ensureProductsGridConfig() {
  if (productsGridConfig.loaded) return Promise.resolve(productsGridConfig.value);
  if (inflight) return inflight;

  inflight = fetchSetting('products_grid')
    .then((record) => {
      productsGridConfig.value = parseProductsGridConfig(record?.value);
      productsGridConfig.loaded = true;
      return productsGridConfig.value;
    })
    .catch(() => {
      productsGridConfig.value = null;
      productsGridConfig.loaded = true;
      return null;
    })
    .finally(() => {
      inflight = null;
    });

  return inflight;
}