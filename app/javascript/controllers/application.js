import { Application } from "@hotwired/stimulus"
import AutoSubmit from "@stimulus-components/auto-submit"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

application.register("auto-submit", AutoSubmit)

export { application }
