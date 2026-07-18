import { mdsvex } from "mdsvex";
import tailwindcss from "@tailwindcss/vite";
import adapter from "@sveltejs/adapter-auto";
import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";
import { resolve } from "path";

export default defineConfig({
  resolve: {
    alias: {
      $lib: resolve("./src/lib"),
    },
  },
  plugins: [
    tailwindcss(),
    sveltekit({
      compilerOptions: {
        runes: ({ filename }) =>
          filename.split(/[/\\]/).includes("node_modules") ? undefined : true,
        experimental: { async: true },
      },
      adapter: adapter(),
      preprocess: [mdsvex({ extensions: [".svx", ".md"] })],
      extensions: [".svelte", ".svx", ".md"],
      experimental: { remoteFunctions: true },
    }),
  ],
});
