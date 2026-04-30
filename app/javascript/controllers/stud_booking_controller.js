import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dependent-dropdown"
export default class extends Controller {
  static targets = ["stable", "mares", "fee"]
  static values = {
    maresUrl: String,
    placeholder: String,
    studStableId: Number,
    studFee: Number,
    selectedStableId: Number,
    selectedMareId: Number,
    selectedSlotId: Number
  }

  connect() {
    if (this.stableTarget.value) {
      this.loadMares()
      this.loadFee()
    }
  }

  stableChanged() {
    this.clearMare()
    this.clearFee()

    if (this.stableTarget.value) {
      this.loadMares()
      this.loadFee()
    }
  }

  async loadMares() {
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

  loadFee() {
    if (this.studStableIdValue == this.stableTarget.value) {
      this.feeTarget.value = 0
    } else {
      this.feeTarget.value = this.studFeeValue
    }
  }

  populateSelect(selectElement, options) {
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
    this.maresTarget.innerHTML = '<option value="">${this.placeholderValue}</option>'
    this.maresTarget.disabled = true
  }

  clearFee() {
    console.log("clear fee")
    this.feeTarget.innerHtml = this.studFeeValue
  }
}
