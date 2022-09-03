// ***********************************************************
// This example support/e2e.js is processed and
// loaded automatically before your test files.
//
// This is a great place to put global configuration and
// behavior that modifies Cypress.
//
// You can change the location of this file or turn off
// automatically serving support files with the
// 'supportFile' configuration option.
//
// You can read more here:
// https://on.cypress.io/configuration
// ***********************************************************
import "cypress-watch-and-reload/support"
import "cypress-fail-fast"
import "cypress-axe"
import { commandTimings } from "cypress-timings"
import "./commands"

commandTimings()

// hooks
beforeEach(() => {
  Cypress.log({
    name: "reset state",
    displayName: "Reset DB"
  })
  cy.request("/cypress_rails_reset_state")
  cy.request({
    url: "/test/session",
    method: "delete",
    form: true,
    failOnStatusCode: true
  })
})
