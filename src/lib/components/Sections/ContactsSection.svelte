<script>
  import { t } from '$lib/common/translations.js';
  import Image from '$lib/components/Common/Image.svelte';

  let { section } = $props();
  const data = $derived(section.parsedData || {});
  const sectionDef = $derived(section.expand?.section || {});
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

  <div class="w-full rounded-box border border-base-200 bg-base-100 shadow-sm overflow-hidden flex flex-col lg:flex-row">
    
    <div class="w-full lg:w-1/2 p-6 sm:p-8 flex flex-col justify-center space-y-6">
      
      {#if data.company_name}
        <div>
          <p class="text-xs font-bold uppercase tracking-widest text-primary mb-1">Организация</p>
          <p class="text-xl font-semibold text-base-content">{data.company_name}</p>
        </div>
      {/if}

      <div class="space-y-5">
        {#if data.office_address}
          <div>
            <p class="text-xs font-bold uppercase tracking-widest text-primary mb-1">Адрес</p>
            <p class="text-base font-medium text-base-content">{data.office_address}</p>
            {#if data.legal_address && data.legal_address !== data.office_address}
              <p class="text-sm text-base-content/60 mt-1">Юр. адрес: {data.legal_address}</p>
            {/if}
          </div>
        {/if}

        {#if data.phone}
          <div>
            <p class="text-xs font-bold uppercase tracking-widest text-primary mb-1">Телефон</p>
            <a href={`tel:${data.phone.replace(/\D/g, '')}`} class="text-lg font-semibold text-base-content hover:text-primary transition-colors">
              {data.phone}
            </a>
          </div>
        {/if}

        {#if data.email}
          <div>
            <p class="text-xs font-bold uppercase tracking-widest text-primary mb-1">Email</p>
            <a href={`mailto:${data.email}`} class="text-base font-medium text-base-content hover:text-primary transition-colors">
              {data.email}
            </a>
          </div>
        {/if}
      </div>

      {#if data.inn || data.kpp}
        <div class="pt-5 border-t border-base-200">
          <p class="text-xs font-bold uppercase tracking-widest text-base-content/50 mb-2">Реквизиты</p>
          <div class="text-sm text-base-content/70 space-y-1">
            {#if data.inn}<p>ИНН: <span class="text-base-content font-medium">{data.inn}</span></p>{/if}
            {#if data.kpp}<p>КПП: <span class="text-base-content font-medium">{data.kpp}</span></p>{/if}
          </div>
        </div>
      {/if}
    </div>

    <div class="w-full lg:w-1/2 min-h-[400px] lg:min-h-full bg-base-200 relative">
      {#if data.geo}
        {@const coords = data.geo.split(',').map(c => c.trim())}
        {@const lon = coords[0]}
        {@const lat = coords[1]}
        
        <iframe 
          src="https://yandex.ru/map-widget/v1/?ll={lon}%2C{lat}&z=15&pt={lon},{lat},pm2rdm"
          class="absolute inset-0 w-full h-full border-0"
          allowfullscreen
        ></iframe>
      {:else}
        <div class="absolute inset-0 flex flex-col items-center justify-center text-base-content/40">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          <p class="text-sm font-medium">Ошибка загрузки карты</p>
        </div>
      {/if}
    </div>

  </div>
</section>