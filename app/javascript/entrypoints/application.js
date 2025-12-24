// import debug from "debug"

import "@hotwired/turbo-rails"

// invokers polyfill for commandfor / command
import "invokers-polyfill"

// Safari polyfill for closedby
import { apply, isSupported } from "@fractaledmind/dialog-closedby-polyfill"
import "../controllers"

if (!isSupported()) {
  apply()
}

const dialog = document.getElementById("turbo-confirm-dialog")
const titleElement = document.getElementById("turbo-confirm-title")
const messageElement = document.getElementById("turbo-confirm-message")
const confirmButton = dialog?.querySelector("button[value='confirm']")

window.Turbo.config.forms.confirm = (message, element, submitter) => {
  // Fall back to native confirm if dialog isn't in the DOM
  if (!dialog) return Promise.resolve(confirm(message))

  messageElement.textContent = message

  // Allow custom title text via data-turbo-confirm-title
  titleElement.textContent = submitter?.dataset.turboConfirmTitle || "Confirm"
  // Allow custom button text via data-turbo-confirm-button
  confirmButton.textContent = submitter?.dataset.turboConfirmButton || "Yes, go ahead"

  if (dialog.hasAttribute("open")) {
    dialog.close()
  }
  dialog.showModal()

  return new Promise(resolve => {
    dialog.addEventListener(
      "close",
      () => {
        resolve(dialog.returnValue === "confirm")
      },
      { once: true }
    )
  })
}

// The default of 500ms is too long and users can lose the causal
// link between clicking a link and seeing the browser respond
window.Turbo.config.drive.progressBarDelay = 100

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
