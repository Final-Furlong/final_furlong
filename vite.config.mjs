import { defineConfig } from "vite"
import Rails from "vite-plugin-rails"
import { VitePluginRadar } from "vite-plugin-radar"
import tailwindcss from "@tailwindcss/vite"

export default defineConfig(configEnv => ({
  plugins: [
    Rails({
      envVars: { RAILS_ENV: process.env.RAILS_ENV || "development" },
      fullReload: {
        additionalPaths: ["app/assets/**/*", "app/content/**/*"]
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
