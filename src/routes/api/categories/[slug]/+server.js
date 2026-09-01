import { json } from '@sveltejs/kit';
import PocketBase from 'pocketbase';
import { config } from "$lib/common/config.js";

export async function GET({ params, url }) {
  const pb = new PocketBase(config.pocketbase.url);
  const slug = params.slug;
  
  try {
    const category = await pb.collection('categories').getFirstListItem(`slug="${slug}"`);
    return json(category);
  } catch (e) {
    return new Response(JSON.stringify({ error: 'Category not found' }), { status: 404 });
  }
}