import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"

export default class extends Controller {
  static values = { url: String, placeholder: String, turboFrame: String }
  static targets = ["select", "frame"]

  change() {
    const value = this.selectTarget.value
    let url = this.urlValue.replace(this.placeholderValue, value)

    fetch(url, { headers: { Accept: "text/vnd.turbo-stream.html" } })
      .then(response => response.text())
      .then(html => window.Turbo.renderStreamMessage(html))
  }
}
