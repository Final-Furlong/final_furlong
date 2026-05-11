import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["form"]
  static values = { delay: { type: Number, default: 300 } }

  fetchAndUpdate(event) {
    event.preventDefault()

    this.formTarget
      .submit()
      .then(response => (response.ok ? response.text() : Promise.reject("Response not OK")))
      .then(html => Turbo.renderStreamMessage(html))
      .catch(error => console.error("Error:", error))
  }

  reset(event) {
    event.preventDefault()
    let form = this.formTarget
    let preventSubmit = event.currentTarget.dataset.preventSubmit
    let clearErrors = event.currentTarget.dataset.clearErrors

    this.resetFields(form, preventSubmit, clearErrors)
  }

  resetFields(form, preventSubmit, clearErrors) {
    let inputs = form.getElementsByTagName("input")
    for (let i = 0; i < inputs.length; i++) {
      let input = inputs[i]

      console.log(input.type)
      if (input.type === "select-one") {
        input.prop("selectedIndex", 0).trigger("selectFilterReseted")
      } else if (input.type === "radio" || input.type === "checkbox") {
        input.checked = false
      } else if (input.type !== "submit") {
        input.value = ""
      }

      if (clearErrors) {
        input.classList.remove("is-invalid")
      }
    }

    let selects = form.getElementsByTagName("select")
    for (let i = 0; i < selects.length; i++) {
      let select = selects[i]

      select.value = ""

      if (clearErrors) {
        select.classList.remove("is-invalid")
      }
    }

    let calendars = form.getElementsByTagName("calendar-range")
    for (let i = 0; i < calendars.length; i++) {
      let calendar = calendars[i]

      calendar.value = ""
    }

    if (clearErrors) {
      document.getElementById("messages").innerHTML = ""
    }

    if (!preventSubmit) {
      this.formTarget.requestSubmit()
    }
  }

  submitDebounced() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.delayValue)
  }
}
