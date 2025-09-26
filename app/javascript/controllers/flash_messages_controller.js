import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash"]
  static values = {
    dismissFlashTimeout: { type: Number, default: 3 }
  }

  connect() {
    if (this.dismissFlashTimeoutValue > 0) {
      console.log("set timeout")
      setTimeout(this.dismissFlash, this.dismissFlashTimeoutValue * 1000)
    }
  }

  dismissFlash = () => {
    this.element.classList.add("transform", "opacity-0", "transition", "duration-1000")
    setTimeout(() => this.flashTarget.remove(), 1000)
  }
}
