// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

// The default of 500ms is too long and
// users can lose the causal link between clicking
// a link and seeing the browser respond
/* eslint-disable no-undef */
if (typeof Turbo.config !== "undefined") {
  Turbo.config.drive.progressBarDelay = 100
}
/* eslint-enable no-undef */

// disable turbo temporarily
// Turbo.session.drive = false
