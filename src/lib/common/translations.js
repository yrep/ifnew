// src/lib/common/translations.js
const dictionaries = {
  ru: {
    errors: {
      loadPageDataError: "Не удалось загрузить данные страницы.",
      loadProductsError: "Не удалось загрузить список товаров.",
    },
    common: {
      loadMore: "Загрузить еще",
    },
  },
};

export function t(key, locale = "ru") {
  const keys = key.split(".");
  let value = dictionaries[locale] || dictionaries.ru;
  for (const k of keys) {
    if (value === undefined) return key;
    value = value[k];
  }
  return value || key;
}
