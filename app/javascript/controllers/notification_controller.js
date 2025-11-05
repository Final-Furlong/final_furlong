import { Application } from "@hotwired/stimulus"
import Notification from "@stimulus-components/notification"

const application = Application.start()
application.register("notification", Notification)

export default class extends Notification {
  static values = {
    delay: { type: Number, default: 5000 },
    hidden: { type: Boolean, default: false },
    dismiss: { type: Boolean, default: true }
  }

  connect() {
    super.connect()
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
