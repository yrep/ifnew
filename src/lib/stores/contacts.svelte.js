// src/lib/stores/contacts.svelte.js
import { config } from "$lib/common/config.js";
import { parseCsvData } from "$lib/common/csvParser.js";

export const contactsStore = $state({
  address: '',
  phone: '',
  email: '',
  loaded: false,
  loading: false
});

export async function loadContacts() {
  if (contactsStore.loading || contactsStore.loaded) return;
  
  contactsStore.loading = true;
  try {
    const url = `${config.pocketbase.url}/api/collections/sections/records?filter=(code='contacts_main')&limit=1`;
    const res = await fetch(url);
    
    if (!res.ok) {
      throw new Error(`PocketBase error: ${res.status}`);
    }
    
    const data = await res.json();
    const record = data.items?.[0];
    
    if (record?.data_fields) {
      const parsed = parseCsvData(record.data_fields);
      contactsStore.address = parsed.office_address || '';
      contactsStore.phone = parsed.phone || '';
      contactsStore.email = parsed.email || '';
      contactsStore.loaded = true;
    }
  } catch (err) {
    console.error('Не удалось загрузить контакты для футера:', err);
  } finally {
    contactsStore.loading = false;
  }
}