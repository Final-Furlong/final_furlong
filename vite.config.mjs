import tailwindcss from "@tailwindcss/vite"
import rails from "rails-vite-plugin"
import { defineConfig } from "vite"
import manifestSRI from "vite-plugin-manifest-sri"
import { VitePluginRadar } from "vite-plugin-radar"

export default defineConfig(_configEnv => ({
  plugins: [
    rails({
      sourceDir: "app/javascript"
    }),
    manifestSRI(),
    VitePluginRadar({
      simpleanalytics: {
        enabled: process.env.RAILS_ENV == "production"
      }
    }),
    tailwindcss()
  ]
}))
