// src/routes/api/form-requests/+server.js
import { json } from "@sveltejs/kit";
import { pb } from "$lib/server/pocketbase.js";

export async function POST({ request }) {
  try {
    const data = await request.json();

    const body = {
      type: data.type || "callback",
      company_name: data.company_name || "",
      contact_name: data.contact_name || "",
      phone: data.phone || "",
      email: data.email || "",
      text: data.text || "",
      city: data.city || "",
      processed: false,
      sent: false,
      approved: data.type === "feedback" ? false : true,
    };

    const record = await pb.collection("form_requests").create(body);

    return json(
      {
        success: true,
        message: "Заявка успешно отправлена! Мы свяжемся с вами.",
        id: record.id,
      },
      { status: 200 },
    );
  } catch (err) {
    console.error("❌ Ошибка создания записи в form_requests:", err);

    return json(
      {
        success: false,
        error: err.message || "Ошибка сервера при сохранении заявки",
      },
      { status: 500 },
    );
  }
}
