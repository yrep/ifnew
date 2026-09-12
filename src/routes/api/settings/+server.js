import { json, error } from '@sveltejs/kit';
import { pb } from '$lib/server/pocketbase.js';

export async function GET({ url }) {
  const key = url.searchParams.get('key');
  const group = url.searchParams.get('group');

  try {
    if (key) {
      const record = await pb
        .collection('settings')
        .getFirstListItem(`key = "${key}"`);
      return json(record);
    }
    const items = await pb.collection('settings').getFullList({
      filter: group ? `group = "${group}"` : '',
    });
    return json({ items });
  } catch (err) {
    throw error(404, err?.message || 'not found');
  }
}