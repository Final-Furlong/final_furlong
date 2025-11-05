import { Application } from "@hotwired/stimulus"
import Notification from "@stimulus-components/notification"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

Stimulus.register("notification", Notification)

export { application }
