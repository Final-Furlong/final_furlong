import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select-with-dependent"

export default class extends Controller {
  static values = {
    url: String,
    param: "id",
    target: String,
    target_name: "name",
    target_value: "id"
  }

  connect() {
    new TomSelect(this.element)
  }

  disconnect() {
    if (this.element.tomselect) {
      this.element.tomselect.destroy()
    }
  }

  update() {
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set(this.paramValue, this.element.value)
    fetch(url, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        const target = document.getElementById(this.targetValue)
        if (target) {
          const valueKey = this.targetValueValue
          const nameKey = this.targetNameValue
          if (target.tomselect) {
            target.tomselect.clearOptions()
            data.forEach(option => {
              target.tomselect.addOption({ value: option[valueKey], text: option[nameKey] })
            })
            target.tomselect.refreshOptions(false)
          } else {
            target.innerHTML = ""
            data.forEach(option => {
              const opt = document.createElement("option")
              opt.value = option[valueKey]
              opt.textContent = option[nameKey]
              target.appendChild(opt)
            })
          }
        }
      })
  }
}
