import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dependent-dropdown"
export default class extends Controller {
  static targets = ["stable", "mares"]
  static values = {
    maresUrl: String,
    placeholder: String,
    selectedStableId: Number,
    selectedMareId: Number,
    selectedSlotId: Number
  }

  connect() {
    console.log(this.stableTarget.value)
    if (this.stableTarget.value) {
      this.loadMares()
    }
  }

  stableChanged() {
    console.log("stable changed")
    this.clearMare()

    if (this.stableTarget.value) {
      this.loadMares()
    }
  }

  async loadMares() {
    console.log("load mares")
    const stableId = this.stableTarget.value
    if (!stableId) return

    try {
      const url = this.maresUrlValue.replace(":stable_id", stableId).replace(":slot_id", this.selectedSlotIdValue)
      const response = await fetch(url)
      const mares = await response.json()

      this.populateSelect(this.maresTarget, mares)
      this.maresTarget.disabled = false

      if (this.hasSelectedMareIdValue) {
        this.maresTarget.value = this.selectedMareIdValue
      }
    } catch (error) {
      console.error("Error loading mares:", error)
    }
  }

  populateSelect(selectElement, options) {
    console.log("popuplate select")
    // Clear existing options except the first placeholder
    selectElement.innerHTML = `<option value="">${this.placeholderValue}</option>`

    // Add new options
    options.forEach(option => {
      const optionElement = document.createElement("option")
      optionElement.value = option.id
      optionElement.textContent = option.name
      selectElement.appendChild(optionElement)
    })
  }

  clearMare() {
    console.log("clear mare")
    this.maresTarget.innerHTML = '<option value="">${this.placeholderValue}</option>'
    this.maresTarget.disabled = true
  }
}
