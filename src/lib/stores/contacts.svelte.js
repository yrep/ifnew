import { fetchPage } from "$lib/frontend/api/pages.js";

export const contacts = $state({
  address: '',
  phone: '',
  email: ''
});

export let loaded = $state(false);
export let loading = $state(false);

function findContactsSection(pageData) {
  const allSections = [
    ...(pageData.beforeContent || []),
    ...(pageData.betweenContent || []),
    ...(pageData.afterContent || [])
  ];
  return allSections.find(s => s.expand?.section?.type === 'contacts');
}

export async function loadContacts() {
  if (loading || loaded) return;
  
  loading = true;
  try {
    const pageData = await fetchPage({ slug: 'contacts' });
    const section = findContactsSection(pageData);
    
    if (section?.parsedData) {
      contacts.address = section.parsedData.office_address || '';
      contacts.phone = section.parsedData.phone || '';
      contacts.email = section.parsedData.email || '';
      loaded = true;
    }
  } catch (err) {
    console.error('Failed to load contacts for footer:', err);
  } finally {
    loading = false;
  }
}