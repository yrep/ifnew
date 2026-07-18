// src/hooks.server.js
import "$lib/common/dlog.js";

export async function handle({ event, resolve }) {
  return resolve(event);
}
