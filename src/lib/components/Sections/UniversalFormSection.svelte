<!-- src/lib/components/Sections/UniversalFormSection.svelte -->
<script>
  import { dlog } from '$lib/common/dlog.js';

  let { section } = $props();
  
  const formCode = $derived(section.expand?.section?.code || 'form_request');

  const formConfigs = {
    'form_request': {
      title: 'Заявка на поставку',
      type: 'order',
      fields: [
        { name: 'company_name', label: 'Название организации', type: 'text', required: true },
        { name: 'contact_name', label: 'Контактное лицо', type: 'text', required: false },
        { name: 'phone', label: 'Телефон', type: 'tel', required: true },
        { name: 'email', label: 'E-mail', type: 'email', required: true },
        { name: 'text', label: 'Текст запроса', type: 'textarea', required: true }
      ]
    },
    'callback': {
      title: 'Обратный звонок',
      type: 'callback',
      fields: [
        { name: 'phone', label: 'Телефон организации', type: 'tel', required: true },
        { name: 'contact_name', label: 'Контактное лицо', type: 'text', required: true }
      ]
    },
    'form_feedback': {
      title: 'Отзывы',
      type: 'feedback',
      fields: [
        { name: 'contact_name', label: 'ФИО', type: 'text', required: true },
        { name: 'email', label: 'E-mail', type: 'email', required: true },
        { name: 'city', label: 'Город', type: 'text', required: false },
        { name: 'text', label: 'Ваше мнение', type: 'textarea', required: true }
      ]
    }
  };

  const config = $derived(formConfigs[formCode] || formConfigs['form_request']);

  let formData = $state({
    company_name: '',
    contact_name: '',
    phone: '',
    email: '',
    text: '',
    city: ''
  });

  let status = $state('idle'); // idle, submitting, success, error
  let responseMsg = $state('');

  function validateForm() {
    const missingFields = [];
    for (const field of config.fields) {
      if (field.required) {
        const value = formData[field.name]?.trim();
        if (!value) {
          missingFields.push(field.label);
        }
      }
    }
    return missingFields;
  }

  async function handleSubmit(e) {
    e.preventDefault();
    
    const missingFields = validateForm();
    if (missingFields.length > 0) {
      status = 'error';
      responseMsg = `Не заполнены обязательные поля: ${missingFields.join(', ')}`;
      return;
    }

    status = 'submitting';
    responseMsg = '';

    const payload = {
      type: config.type,
      company_name: formData.company_name || '',
      contact_name: formData.contact_name || '',
      phone: formData.phone || '',
      email: formData.email || '',
      text: formData.text || '',
      city: formData.city || '',
      processed: false,
      sent: false,
      approved: false,
    };

    try {
      const res = await fetch('/api/form-requests', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || 'Ошибка сервера при отправке');
      
      status = 'success';
      if (config.type === 'feedback') {
        responseMsg = data.message || 'Мы получили ваш отзыв! Спасибо, что поделились своим мнением! Он появится на сайте после модерации.';
      } else {
        responseMsg = data.message || 'Ваше обращение успешно отправлено! Мы свяжемся с вами в ближайшее время.';
      }
      
      // clear the form
      formData = { company_name: '', contact_name: '', phone: '', email: '', text: '', city: '' };
    } catch (err) {
      status = 'error';
      responseMsg = err.message || 'Произошла ошибка при отправке. Попробуйте позже.';
      dlog('API-ERR', 'Ошибка отправки формы', err);
    }
  }
</script>

<section class="py-8 w-full">
  {#if section.expand?.section?.show_heading_excerpt}
    <div class="mb-8 text-center">
      <h2 class="text-3xl font-bold">{section.expand.section.heading}</h2>
      {#if section.expand.section.excerpt}
        <p class="mt-2 text-base-content/70">{section.expand.section.excerpt}</p>
      {/if}
    </div>
  {/if}

    <div class="mx-auto max-w-2xl rounded-box border border-base-200 bg-base-100 p-6 shadow-sm">
    {#if section.expand?.section?.show_heading_excerpt}
      <h3 class="mb-6 text-2xl font-bold text-center">{config.title}</h3>
    {/if}

    {#if status === 'success'}
      <div class="alert alert-success mb-6">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        <span>{responseMsg}</span>
      </div>
    {:else if status === 'error'}
      <div class="alert alert-error mb-6">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        <span>{responseMsg}</span>
      </div>
    {/if}

    <form class="flex flex-col gap-5" onsubmit={handleSubmit}>
      {#each config.fields as field}
        <label class="form-control w-full">
          <span class="label-text mb-1">
            {field.label}
            {#if field.required}
              <span class="text-error">*</span>
            {/if}
          </span>
          
          {#if field.type === 'textarea'}
            <textarea 
              class="textarea textarea-bordered w-full" 
              rows="4" 
              bind:value={formData[field.name]}
              placeholder="Введите текст..."
            ></textarea>
          {:else}
            <input 
              type={field.type} 
              class="input input-bordered w-full" 
              bind:value={formData[field.name]}
              placeholder="Введите данные..."
            />
          {/if}
        </label>
      {/each}

      <button type="submit" class="btn btn-primary mt-2" disabled={status === 'submitting'}>
        {#if status === 'submitting'}
          <span class="loading loading-spinner"></span>
          Отправка...
        {:else}
          Отправить
        {/if}
      </button>
    </form>
  </div>
</section>