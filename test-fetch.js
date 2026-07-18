// test-fetch.js
const url =
  "http://127.0.0.1:8090/api/collections/products/records?page=1&perPage=1";

console.log("🧪 Тестируем fetch из Node.js к:", url);

fetch(url)
  .then(async (res) => {
    const text = await res.text();
    console.log("✅ Ответ получен");
    console.log("Status:", res.status, res.statusText);
    console.log("Body length:", text.length);
    console.log("Body preview:", text.substring(0, 300));
  })
  .catch((err) => {
    console.error("❌ fetch упал");
    console.error("Message:", err.message);
    console.error("Cause:", err.cause);
    console.error("Code:", err.cause?.code);
    console.error("Full error:", err);
  });
