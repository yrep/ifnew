// src/lib/common/productSort.js

export function sortProductsByOrder(items) {
  return items
    .map((item, index) => ({ item, index }))
    .sort((a, b) => {
      const aItem = a.item;
      const bItem = b.item;

      const aOrder = aItem.order;
      const bOrder = bItem.order;
      const aHasOrder = aOrder !== null && aOrder !== undefined && aOrder !== '' && Number(aOrder) > 0;
      const bHasOrder = bOrder !== null && bOrder !== undefined && bOrder !== '' && Number(bOrder) > 0;

      if (aHasOrder && bHasOrder) {
        return Number(aOrder) - Number(bOrder);
      }
      if (aHasOrder && !bHasOrder) return -1;
      if (!aHasOrder && bHasOrder) return 1;

      const aUpdated = aItem.updated;
      const bUpdated = bItem.updated;
      if (aUpdated && bUpdated) {
        return new Date(bUpdated).getTime() - new Date(aUpdated).getTime();
      }
      if (aUpdated && !bUpdated) return -1;
      if (!aUpdated && bUpdated) return 1;

      return a.index - b.index;
    })
    .map(({ item }) => item);
}