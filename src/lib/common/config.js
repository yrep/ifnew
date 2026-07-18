// src/lib/common/config.js
export const config = {
  pocketbase: { url: "http://127.0.0.1:8090" },
  settings: {
    entities: { products: { perPage: 6 } },
    sections: { hero: { maxItems: 5 } },
    menu: {
      header: [
        { title: "Главная", slug: "/", parentSlug: "" },
        { title: "О компании", slug: "/company/", parentSlug: "" },
        { title: "Продукция", slug: "/produkciya/", parentSlug: "" },
        { title: "Партнеры", slug: "/partnery/", parentSlug: "" },
        { title: "Новости", slug: "/news/", parentSlug: "" },
        { title: "Контакты", slug: "/contacts/", parentSlug: "" },
      ],
      footer: {
        groups: [
          [
            { slug: '/', title: 'Главная' },
            { slug: '/company/', title: 'О компании' },
            { slug: '/produkciya/', title: 'Продукция' },
            { slug: '/partnery/', title: 'Партнеры' },
            { slug: '/news/', title: 'Новости' },
            { slug: '/stati/', title: 'Статьи' },
          ],
          [
            { slug: '/otzyvy/', title: 'Отзывы' },
            { slug: '/zayavka-na-postavku/', title: 'Заявка на поставку' },
            { slug: '/obratnyj-zvonok/', title: 'Обратный звонок' },
            { slug: '/sitemap/', title: 'Карта сайта' },
          ]
        ]
      }
    },
  },
};