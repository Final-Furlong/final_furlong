// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

$('#navbar-toggler').on('click', function () {
    $('#sidebar-menu').toggleClass('show');
});