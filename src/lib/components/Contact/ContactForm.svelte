<!-- src/lib/components/Contact/ContactForm.svelte -->
<script>
  import { sendContactForm } from "$lib/frontend/api/contacts.js";

  let name = $state("");
  let phone = $state("");
  let message = $state("");
  let status = $state("idle");
  let responseMessage = $state("");

  async function handleSubmit(e) {
    e.preventDefault();
    status = "submitting";
    responseMessage = "";
    try {
      const res = await sendContactForm({ name, phone, message });
      responseMessage = res.message;
      status = "success";
      name = "";
      phone = "";
      message = "";
    } catch (err) {
      status = "error";
      responseMessage = "Не удалось отправить заявку. Попробуйте позже.";
    }
  }
</script>

<form class="rounded-box border border-base-200 bg-base-100 p-6" onsubmit={handleSubmit}>
  <h2 class="mb-4 text-xl font-semibold">Оставить заявку</h2>

  <label class="form-control mb-3">
    <span class="mb-1 text-sm">Ваше имя</span>
    <input type="text" class="input input-bordered" bind:value={name} required />
  </label>

  <label class="form-control mb-3">
    <span class="mb-1 text-sm">Телефон</span>
    <input type="tel" class="input input-bordered" bind:value={phone} required />
  </label>

  <label class="form-control mb-4">
    <span class="mb-1 text-sm">Сообщение</span>
    <textarea class="textarea textarea-bordered" rows="4" bind:value={message}></textarea>
  </label>

  <button type="submit" class="btn btn-primary w-full" disabled={status === "submitting"}>
    {#if status === "submitting"}
      <span class="loading loading-spinner"></span>
      Отправка...
    {:else}
      Отправить
    {/if}
  </button>

  {#if responseMessage}
    <div class="mt-4">
      <div class={status === "success" ? "alert alert-success" : "alert alert-error"}>
        <span>{responseMessage}</span>
      </div>
    </div>
  {/if}
</form>

