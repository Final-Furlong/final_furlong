import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dependent-dropdown"
export default class extends Controller {
  static targets = ["stable", "mares", "fee"]
  static values = {
    maresUrl: String,
    mareSlotsUrl: String,
    placeholder: String,
    studStableId: Number,
    studFee: Number,
    selectedStudId: Number,
    selectedStableId: Number,
    selectedMareId: Number,
    selectedSlotId: Number,
    selectedStudFee: Number
  }

  connect() {
    if (this.stableTarget.value) {
      this.loadMares()
      this.loadSlots()
      this.loadFee(true)
    }
  }

  async stableChanged() {
    this.clearMare()
    this.clearFee()

    if (this.stableTarget.value) {
      await this.loadMares()
      this.loadSlots()
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
        if (this.mareExists(mares, this.selectedMareIdValue)) {
          this.maresTarget.value = this.selectedMareIdValue
        } else {
          this.maresTarget.value = ""
        }
      }
    } catch (error) {
      console.error("Error loading mares:", error)
    }
  }

  mareExists(list, value) {
    let matching = list.filter(x => x.id == value)
    return matching.length > 0
  }

  async loadSlots() {
    const mareId = this.selectedMareIdValue || this.maresTarget.value
    if (!mareId || mareId == "") return

    try {
      const url = this.mareSlotsUrlValue.replace(":mare_id", mareId).replace(":stud_id", this.selectedStudIdValue)
      const response = await fetch(url)
      const slots = await response.json()

      this.populateSelect(this.slotsTarget, slots)
      this.slotsTarget.disabled = false
    } catch (error) {
      console.error("Error loading mares:", error)
    }
  }

  loadFee(useSelected = false) {
    if (this.studStableIdValue == this.stableTarget.value) {
      this.feeTarget.value = 0
    } else if (useSelected && this.selectedStudFeeValue) {
      this.feeTarget.value = this.selectedStudFeeValue
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
    this.feeTarget.innerHtml = this.studFeeValue
  }
}
