// src/lib/server/api/contacts.js
export async function submitContact({ locale = "ru", payload } = {}) {
  await new Promise((r) => setTimeout(r, 300));
  return {
    ok: true,
    message: "Спасибо! Ваша заявка принята. Мы свяжемся с вами в ближайшее время.",
    receivedAt: new Date().toISOString(),
    locale,
  };
}

