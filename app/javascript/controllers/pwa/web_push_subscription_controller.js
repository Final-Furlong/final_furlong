import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"

const vapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').content

export const hasNotificationPermission = async () => {
  console.log(`Permission to receive notifications has been ${Notification.permission}`)
  switch (Notification.permission) {
    case "granted":
      return Promise.resolve(true)
    case "denied":
      return Promise.resolve(false)
    default: {
      const permission = await Notification.requestPermission()
      console.log(`Permission to receive notifications has been ${permission}`)
      return Promise.resolve(permission === "granted")
    }
  }
}

export const getRegistration = async () => navigator.serviceWorker.ready

export const getSubscription = async () => {
  const registration = await getRegistration()

  return await registration.pushManager.getSubscription()
}

export const createSubscription = async () => {
  const registration = await getRegistration()

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: vapidPublicKey
  })

  return subscription
}

export const unsubscribe = async () => {
  const subscription = await getSubscription()

  if (subscription) {
    // Unsubscribe if we have an existing subscription
    return await subscription.unsubscribe()
  } else {
    return Promise.resolve(false)
  }
}

export default class extends Controller {
  static targets = ["subscribeButton", "unsubscribeButton"]

  initialize() {
    this.error = null
  }

  async connect() {
    if (!window.PushManager) {
      this.setError("Push messaging is not supported in your browser")
    }

    if (!ServiceWorkerRegistration.prototype.showNotification) {
      this.setError("Notifications are not supported in your browser")
      console.error("Push messaging is not supported in your browser")
    }

    const subscription = await getSubscription()

    if (subscription) {
      this.setStatusSubscribed(subscription)
    } else {
      this.resetSubscriptionStatus()
    }
  }

  async trySubscribe() {
    console.log("trySubscribe")
    this.setError(null)
    this.subscribeButtonTarget.disabled = true

    let permissionGranted = await hasNotificationPermission()

    if (permissionGranted) {
      this.subscribe()
    } else {
      this.permissionDenied()
    }
  }

  async unsubscribe() {
    console.log("unsubscribe", "start")
    const result = await unsubscribe()
    this.resetSubscriptionStatus()
    console.log("unsubscribe", "finish", result)
  }

  async subscribe() {
    console.log("subscribe", "start")
    const subscription = (await getSubscription()) || (await createSubscription())

    if (subscription) {
      this.setStatusSubscribed(subscription)
    } else {
      console.error("Web push subscription failed")
    }

    console.log("subscribe", "finish", subscription)
  }

  async setStatusSubscribed(subscription) {
    console.log("setSubscriptionStatusSubscribed", subscription.toJSON())

    this.dispatch("subscription-changed", { detail: { subscription } })

    const {
      endpoint,
      keys: { p256dh, auth }
    } = subscription.toJSON()
    const json_data = { push_subscription: { endpoint, p256dh_key: p256dh, auth_key: auth } }
    const request = new FetchRequest("post", "/push_subscriptions", { body: JSON.stringify(json_data) })
    const response = await request.perform()
    if (!response.ok) {
      console.log("got an error")
      console.log(response)
    }

    this.subscribeButtonTarget.disabled = true
    this.unsubscribeButtonTarget.disabled = false
  }

  resetSubscriptionStatus() {
    this.dispatch("subscription-changed", { detail: { subscription: null } })

    this.subscribeButtonTarget.disabled = false
    this.unsubscribeButtonTarget.disabled = true
  }

  permissionDenied() {
    this.setError(
      "Permission for notifications is denied. Please change your browser settings if you wish to support web push."
    )
    this.subscribeButtonTarget.disabled = false
  }

  setError(error) {
    console.error("setError", error)
    this.dispatch("subscription-error", { detail: { error } })
  }

  disconnect() {
    console.log("disconnect")
  }
}
