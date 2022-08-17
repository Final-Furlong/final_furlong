import { Controller } from "@hotwired/stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.formTarget.addEventListener("turbo:submit-start", this.onSearchStart)
    this.formTarget.addEventListener("turbo:submit-end", this.onSearchEnd)
    this.latestRequestAt = 0
  }

  search = event => {
    if (!this.valid(event)) return
    let thisRequestAt = (this.latestRequestAt = new Date().getTime())
    let searchField = $(event.currentTarget)
    console.log(searchField)
    let form = $(event.currentTarget).closest("form")
    let submit = form.find('input[type="submit"]')
    console.log(submit)

    setTimeout(() => {
      this.load(searchField, thisRequestAt)
    }, 500)
  }

  reset(event) {
    let form = $(event.currentTarget).closest("form")
    let preventSubmit = event.currentTarget.dataset.preventSubmit
    let clearErrors = event.currentTarget.dataset.clearErrors

    this.resetFields(form, preventSubmit, clearErrors)
  }

  resetFields(form, preventSubmit, clearErrors) {
    let inputs = form.find(".form-control")

    inputs.each(function (i, el) {
      let input = $(el)

      if (input.attr("type") === "select") {
        input.prop("selectedIndex", 0)
      } else {
        input.val("")
      }

      if (clearErrors) {
        input.removeClass("is-invalid")
      }
    })

    if (clearErrors) {
      document.getElementById("messages").innerHTML = ""
    }

    $(".input-daterange input").each(function () {
      $(this).datepicker("clearDates")
    })

    if (!preventSubmit) {
      this.formTarget.requestSubmit()
    }
  }

  valid(event) {
    let keystrokesCount = event.target.dataset.minCharacters
    let field = $(event.currentTarget),
      value = field.val()

    if (keystrokesCount == null) return true
    if (value.length < keystrokesCount && value.length != 0) {
      return false
    } else {
      this.formTarget.querySelectorAll("small.form-text").forEach(el => {
        el.classList.add("d-none")
      })
      return true
    }
  }

  load = (searchField, requestedAt) => {
    if (requestedAt != this.latestRequestAt) return null

    this.formTarget.requestSubmit()
  }

  onSearchStart = () => {
    document.dispatchEvent(new Event("nua-busy-start"))
  }

  onSearchEnd = () => {
    document.dispatchEvent(new Event("nua-busy-end"))
  }
}
