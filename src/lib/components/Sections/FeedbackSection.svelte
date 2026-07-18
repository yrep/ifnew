<script>
  import Pagination from '$lib/components/Common/Pagination.svelte';
  import Loader from '$lib/components/Common/Loader.svelte';
  import { page } from '$app/state';
  import { onMount } from 'svelte';

  let { section } = $props();
  const sectionDef = $derived(section.expand?.section || {});
  
  const currentPage = $derived(parseInt(page.url.searchParams.get('page') || '1', 10));
  const basePath = $derived(page.url.pathname);
  
  let feedbacks = $state([]);
  let totalPages = $state(1);
  let loading = $state(true);

  async function loadFeedback() {
    loading = true;
    try {
      const res = await fetch(`/api/feedback?page=${currentPage}`);
      const data = await res.json();
      feedbacks = data.items || [];
      totalPages = data.totalPages || 1;
    } catch (err) {
      feedbacks = [];
    } finally {
      loading = false;
    }
  }

  onMount(loadFeedback);
  
  $effect(() => {
    currentPage; // trigger
    loadFeedback();
  });

  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
  }
</script>

<section class="py-8 w-full">
  {#if sectionDef.show_heading_excerpt}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{sectionDef.heading}</h2>
      {#if sectionDef.excerpt}
        <p class="mt-2 text-base-content/70">{sectionDef.excerpt}</p>
      {/if}
    </div>
  {/if}

  {#if loading}
    <div class="flex justify-center py-8">
      <Loader />
    </div>
  {:else if feedbacks.length > 0}
    <div class="flex flex-col gap-4 max-w-3xl mx-auto">
      {#each feedbacks as feedback (feedback.id)}
        <div class="card bg-base-100 shadow-sm border border-base-200">
          <div class="card-body">
            <div class="flex items-start justify-between mb-3">
              <div>
                <h3 class="font-semibold text-lg">{feedback.contact_name}</h3>
                {#if feedback.company_name}
                  <p class="text-sm text-base-content/70">{feedback.company_name}</p>
                {/if}
              </div>
              <span class="badge badge-outline badge-sm">{formatDate(feedback.created)}</span>
            </div>
            <p class="text-base-content/90">{feedback.text}</p>
          </div>
        </div>
      {/each}
    </div>

    <Pagination {currentPage} {totalPages} {basePath} />
  {:else}
    <p class="text-center text-base-content/60 py-8">Отзывов пока нет</p>
  {/if}
</section>