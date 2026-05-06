// Entry point for Vite
import { Turbo } from "@hotwired/turbo-rails"

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target)
}
