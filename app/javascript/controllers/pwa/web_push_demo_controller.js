import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sendPushDemoFieldset", "notificationButton", "subscriptionField", "error", "status"]
  static values = {
    pushNotSupported: String,
    notificationsNotSupported: String,
    browserSubscribed: String,
    browserUnsubscribed: String
  }

  initialize() {
    this.error = null
  }

  async connect() {
    if (!window.PushManager) {
      this.setError(this.pushNotSupportedValue)
    }

    if (!ServiceWorkerRegistration.prototype.showNotification) {
      this.setError(this.notificationsNotSupportedValue)
    }
  }

  onSubscriptionChanged({ detail: { subscription } }) {
    this.setSubscription(subscription)
  }

  onError({ detail: { error } }) {
    console.log("onError")
    this.setError(error)
  }

  setSubscription(subscription) {
    if (subscription) {
      this.statusTarget.textContent = this.browserSubscribedValue
      this.subscriptionFieldTarget.value = JSON.stringify(subscription)
      this.sendPushDemoFieldsetTarget.disabled = false
    } else {
      this.statusTarget.textContent = this.browserUnsubscribedValue
      this.subscriptionFieldTarget.value = ""
      this.sendPushDemoFieldsetTarget.disabled = true
    }
  }

  setError(error) {
    console.warn("setError", error)
    const message = error ? error.message || error : ""

    this.errorTarget.textContent = message

    if (message.length) {
      this.errorTarget.classList.remove("hidden")
    } else {
      this.errorTarget.classList.add("hidden")
    }
  }

  disconnect() {
    console.log("disconnect")
  }
}
