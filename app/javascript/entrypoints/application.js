// import debug from "debug"

import "@hotwired/turbo-rails"

import TC from "@rolemodel/turbo-confirm"

TC.start()

// The default of 500ms is too long and users can lose the causal
// link between clicking a link and seeing the browser respond
Turbo.config.drive.progressBarDelay = 100

import "../controllers"

// disable turbo temporarily
// Turbo.session.drive = false

// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails")

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

// Example: Load Rails libraries in Vite.
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'

// set up service worker
function registerServiceWorker() {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js").catch(error => {
      console.error("Service worker registration failed:", error)
    })
  })
}

if ("serviceWorker" in navigator) {
  registerServiceWorker()
}

if ("setAppBadge" in navigator) {
  navigator.setAppBadge(0)
}
