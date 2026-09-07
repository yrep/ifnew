// src/lib/stores/contacts.svelte.js
import { fetchPage } from "$lib/frontend/api/pages.js";

export const contactsStore = $state({
  address: '',
  phone: '',
  email: '',
  loaded: false,
  loading: false
});

function findContactsSection(pageData) {
  const allSections = [
    ...(pageData.beforeContent || []),
    ...(pageData.betweenContent || []),
    ...(pageData.afterContent || [])
  ];
  return allSections.find(s => s.expand?.section?.type === 'contacts');
}

export async function loadContacts() {
  if (contactsStore.loading || contactsStore.loaded) return;
  
  contactsStore.loading = true;
  try {
    const pageData = await fetchPage({ slug: 'contacts' });
    const section = findContactsSection(pageData);
    
    if (section?.parsedData) {
      contactsStore.address = section.parsedData.office_address || '';
      contactsStore.phone = section.parsedData.phone || '';
      contactsStore.email = section.parsedData.email || '';
      contactsStore.loaded = true;
    }
  } catch (err) {
    console.error('Failed to load contacts for footer:', err);
  } finally {
    contactsStore.loading = false;
  }
}