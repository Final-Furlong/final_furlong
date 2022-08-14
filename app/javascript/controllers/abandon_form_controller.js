import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    confirmMessage: String
  }

  connect() {
    this.initialForm = this.serializeForm(this.element)

    document.addEventListener("submit", this.onSubmitEvent)
    document.addEventListener("turbo:before-visit", this.onLocationChange)
  }

  disconnect() {
    document.removeEventListener("submit", this.onSubmitEvent)
    document.removeEventListener("turbo:before-visit", this.onLocationChange)
  }

  onSubmitEvent = () => {
    this.submitEvent = true
  }

  onLocationChange = event => {
    if (this.submitEvent) return

    let currentForm = this.element

    if (currentForm && this.initialForm != this.serializeForm(currentForm)) {
      if (!confirm(this.confirmMessageValue)) {
        event.preventDefault()
      }
    }
  }

  serializeForm = form => {
    let formData = new FormData(form)
    let formArray = Array.from(formData.entries()).filter((entry, index, array) => {
      // Skip token and hidden fields that as a rule go after visible inputs (related to phone numbers)
      return (
        entry[0] != "authenticity_token" &&
        array[index - 1] &&
        (entry[0] != array[index - 1][0] || entry[1] != array[index - 1][1])
      )
    })

    return JSON.stringify(formArray)
  }
}
