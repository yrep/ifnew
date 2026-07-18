import { json } from '@sveltejs/kit';

export async function GET({ url }) {
  const page = parseInt(url.searchParams.get('page') || '1', 10);
  const perPage = 10;

  try {
    const filter = encodeURIComponent('type="feedback" && approved=true');
    const sort = encodeURIComponent('-created');
    
    const res = await fetch(
      `http://127.0.0.1:8090/api/collections/form_requests/records?page=${page}&perPage=${perPage}&filter=${filter}&sort=${sort}`
    );
    
    if (!res.ok) throw new Error('Failed to fetch');
    
    const data = await res.json();
    
    return json({
      items: data.items,
      totalPages: data.totalPages,
      currentPage: data.page
    });
  } catch (err) {
    return json({ error: 'Failed to load feedback', items: [], totalPages: 1 }, { status: 500 });
  }
}