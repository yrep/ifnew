import { config } from '$lib/common/config.js';
import { parseCsvData } from '$lib/common/csvParser.js';

export const trailingSlash = "always";

export const load = async ({ cookies }) => {
  const locale = cookies.get("locale") || "ru";

  // Загружаем контакты из PocketBase
  let contacts = { address: '', phone: '', email: '' };
  try {
    const res = await fetch(
      `${config.pocketbase.url}/api/collections/sections/records?filter=(code='contacts_main')&limit=1`
    );
    if (res.ok) {
      const data = await res.json();
      const record = data.items?.[0];
      if (record?.data_fields) {
        const parsed = parseCsvData(record.data_fields);
        contacts.address = parsed.office_address || '';
        contacts.phone = parsed.phone || '';
        contacts.email = parsed.email || '';
      }
    }
  } catch (error) {
    console.error('Ошибка загрузки контактов для футера:', error);
  }

  return { locale, contacts };
};