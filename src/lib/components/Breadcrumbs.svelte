<script>
  import { page } from '$app/state';

  let { currentTitle = '' } = $props();

  const slugLabels = {
    'produkciya': 'Продукция',
    'news': 'Новости',
    'stati': 'Статьи',
    'company': 'О компании',
    'contacts': 'Контакты',
  };

  const crumbs = $derived.by(() => {
    const path = page.url.pathname;
    const parts = path.split('/').filter(p => p.length > 0);
    
    const result = [{ label: 'Главная', href: '/', isLast: parts.length === 0 }];
    let current = '';
    
    for (let i = 0; i < parts.length; i++) {
      current += '/' + parts[i];
      const isLast = i === parts.length - 1;
      
      let label = slugLabels[parts[i]] || parts[i];
      if (isLast && currentTitle) {
        label = currentTitle;
      }

      result.push({
        label: label,
        href: current + '/',
        isLast: isLast
      });
    }
    return result;
  });
</script>

{#if crumbs.length > 1}
  <div class="breadcrumbs text-sm mb-6 text-base-content">
    <ul>
      {#each crumbs as crumb}
        <li>
          {#if crumb.isLast}
            <span class="opacity-70">{crumb.label}</span>
          {:else}
            <a href={crumb.href} class="hover:underline">
              {crumb.label}
            </a>
          {/if}
        </li>
      {/each}
    </ul>
  </div>
{/if}