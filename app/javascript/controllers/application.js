import { Application } from "@hotwired/stimulus"
import AutoSubmit from "@stimulus-components/auto-submit"
import CheckboxSelectAll from "@stimulus-components/checkbox-select-all"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

application.register("auto-submit", AutoSubmit)
application.register("checkbox-select-all", CheckboxSelectAll)

export { application }

document.addEventListener("turbo:frame-missing", event => {
  const {
    detail: { response, visit }
  } = event
  event.preventDefault()
  visit(response) // you have to render your "application" layout for this
})
