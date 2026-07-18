// src/routes/+layout.server.js
export const load = async ({ cookies }) => {
  const locale = cookies.get("locale") || "ru";
  return { locale };
};

// src/routes/+layout.server.js
export const trailingSlash = "always";
