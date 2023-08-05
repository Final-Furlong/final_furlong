// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

import "bootstrap"

const navMenu = document.getElementById("sidebar-menu")
const hideIcon = document.getElementById("icon-hide-sidenav")
const showIcon = document.getElementById("icon-show-sidenav")

navMenu.addEventListener("hide.bs.collapse", () => {
  showIcon.classList.remove("d-none")
  hideIcon.classList.add("d-none")
})
navMenu.addEventListener("show.bs.collapse", () => {
  hideIcon.classList.remove("d-none")
  showIcon.classList.add("d-none")
})
