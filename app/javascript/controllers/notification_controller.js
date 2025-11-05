import Notification from "@stimulus-components/notification"

export default class extends Notification {
  static values = {
    delay: { type: Number, default: 3000 },
    hidden: { type: Boolean, default: false },
    dismiss: { type: Boolean, default: true }
  }

  connect() {
    super.connect()
  }

  async remove() {
    await this.leave()

    this.element.remove()
  }

  async hide() {
    if (!this.dismissValue) {
      return
    }

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    await this.leave()

    this.element.remove()
  }
}
