import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="countdown"

export default class extends Controller {
  static values = { time: Number }
  static targets = ["days", "hours", "minutes", "seconds"]

  connect() {
    let display = {
      days: this.daysTarget,
      hours: this.hoursTarget,
      minutes: this.minutesTarget,
      seconds: this.secondsTarget
    }
    this.startCountdown(this.timeValue, display)
  }

  startCountdown(duration, display) {
    let timer = duration,
      days,
      hours,
      minutes,
      seconds
    setInterval(() => {
      days = Math.floor(timer / (60 * 60 * 24))
      hours = Math.floor((timer % (60 * 60 * 24)) / (60 * 60))
      minutes = Math.floor((timer % (60 * 60)) / 60)
      seconds = Math.floor(timer % 60)

      display.days.textContent = days
      display.hours.textContent = hours
      display.minutes.textContent = minutes
      display.seconds.textContent = seconds

      if (--timer < 0) {
        timer = duration
      }
    }, 1000)
  }
}
