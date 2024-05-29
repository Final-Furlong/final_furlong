// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

import "bootstrap"

const navMenu = document.getElementById("sidebar-menu")
const hideIcon = document.getElementById("icon-hide-sidenav")
const showIcon = document.getElementById("icon-show-sidenav")

function hideElement(element) {
  element.classList.add("d-none")
}

function showElement(element) {
  element.classList.remove("d-none")
}

navMenu.addEventListener("hide.bs.collapse", () => {
  showElement(showIcon)
  hideElement(hideIcon)
})
navMenu.addEventListener("show.bs.collapse", () => {
  showElement(hideIcon)
  hideElement(showIcon)
})
