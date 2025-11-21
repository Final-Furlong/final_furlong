import tailwindcss from "@tailwindcss/vite"
import { defineConfig } from "vite"
import { VitePluginRadar } from "vite-plugin-radar"
import Rails from "vite-plugin-rails"

export default defineConfig(_configEnv => ({
  plugins: [
    Rails({
      envVars: { RAILS_ENV: process.env.RAILS_ENV || "development" },
      fullReload: {
        additionalPaths: ["app/assets/**/*", "app/content/**/*", "config/locales/**/*", "app/views/**/*"]
      }
    }),
    VitePluginRadar({
      simpleanalytics: {
        enabled: true
      }
    }),
    tailwindcss()
  ]
}))
