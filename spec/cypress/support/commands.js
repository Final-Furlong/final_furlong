// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

function terminalLog(violations) {
  cy.task(
    "log",
    `${violations.length} accessibility violation${violations.length === 1 ? "" : "s"} ${
      violations.length === 1 ? "was" : "were"
    } detected`
  )
  // pluck specific keys to keep the table readable
  const violationData = violations.map(({ id, impact, description, nodes }) => ({
    id,
    impact,
    description,
    nodes: nodes.length
  }))

  cy.task("table", violationData)
}

Cypress.Commands.add("factoryBotCreate", args => {
  Cypress.log({
    name: "create factory",
    // shorter name for the Command Log
    displayName: "Factory Bot",
    message: `${args}`,
    consoleProps: () => {
      return {
        Factory: args.factory,
        Strategy: args.strategy,
        Traits: args.traits,
        Attributes: args
      }
    }
  })

  cy.request({
    url: "/test/factories",
    method: "post",
    form: true,
    failOnStatusCode: true,
    body: args
  })

  // cy.factoryBotCreate({
  //   factory: 'user',
  //   traits: ['admin','has_posts'],
  //   name: 'tbconroy',
  //   email: 'tbconroy@example.com'
  // })
})

Cypress.Commands.add("login", args => {
  cy.request({
    url: "/test/sessions",
    method: "post",
    form: true,
    failOnStatusCode: true,
    body: args
  })

  // cy.login({ username: 'abc123' }) || cy.login({ id: '123' })
})

Cypress.Commands.add("getBySel", (selector, ...args) => {
  return cy.get(`[data-test=${selector}]`, ...args)
})

Cypress.Commands.add("getBySelLike", (selector, ...args) => {
  return cy.get(`[data-test*=${selector}]`, ...args)
})

Cypress.Commands.add("printA11y", (context = null, ...options) => {
  return cy.checkA11y(context, options || {}, terminalLog)
})

Cypress.Commands.add("testA11y", (url, context = null, ...options) => {
  cy.visit(url)
  cy.injectAxe()
  cy.printA11y(context, options || {})
})
