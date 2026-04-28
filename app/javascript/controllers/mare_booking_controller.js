import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="dependent-dropdown"
export default class extends Controller {
  static targets = ["stud", "requestStud", "slot", "form"]
  static values = {
    bookingUrl: String,
    placeholder: String
  }

  loadPickDateButton() {
    const studId = this.studTarget.value
    let url = this.bookingUrlValue.replace("stud_id=x", `stud_id=${studId}`)
    this.fetchAndUpdate(url)
  }

  loadRequestBookingButton() {
    const studId = this.requestStudTarget.value
    let url = this.bookingUrlValue.replace("stud_id=x", `stud_id=${studId}`)
    this.fetchAndUpdate(url)
  }

  fetchAndUpdate(url) {
    let csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    fetch(url, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html, text/html, application/xhtml+xml",
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-Token": csrfToken,
        "Cache-Control": "no-cache"
      }
    })
      .then(response => (response.ok ? response.text() : Promise.reject("Response not OK")))
      .then(html => Turbo.renderStreamMessage(html))
      .catch(error => console.error("Error:", error))
  }
}
