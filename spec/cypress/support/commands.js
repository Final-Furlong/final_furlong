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

Cypress.Commands.add("factory", args => {
  Cypress.log({
    name: "create factory via FactoryBot",
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

  // cy.factory({
  //   factory: 'user',
  //   traits: ['admin','has_posts'],
  //   name: 'tbconroy',
  //   email: 'tbconroy@example.com'
  // })
})

Cypress.Commands.add("updateRecord", args => {
  Cypress.log({
    name: "update model",
    displayName: "Update Record",
    message: `${args}`,
    consoleProps: () => {
      return {
        ID: args.id,
        Model: args.model,
        Attributes: args
      }
    }
  })

  cy.request({
    url: "/test/factory",
    method: "put",
    form: true,
    failOnStatusCode: true,
    body: args
  })

  // cy.updateRecord({ model: 'user', id: 'abc123', email: 'updated_email@example.com' })
})

Cypress.Commands.add("findRecord", args => {
  Cypress.log({
    name: "find model",
    displayName: "Find Record",
    message: `${args}`,
    consoleProps: () => {
      return {
        ID: args.id,
        Model: args.model
      }
    }
  })

  cy.request({
    url: "/test/factory",
    method: "get",
    form: false,
    failOnStatusCode: true,
    body: args
  })

  // cy.findRecord({ model: 'user', id: 'abc123' })
})

Cypress.Commands.add("login", args => {
  Cypress.log({
    name: "Login",
    message: `${args}`,
    consoleProps: () => {
      return {
        Username: args.username,
        ID: args.id
      }
    }
  })

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

Cypress.Commands.add("assertUrl", (basePath = "", chainer = "eq") => {
  let path
  if (basePath.charAt(0) == "/") {
    path = basePath.slice(1)
  } else {
    path = basePath
  }
  let url
  if (chainer == "contains") {
    url = path
  } else {
    url = Cypress.config().baseUrl + path
  }
  Cypress.log({
    name: "Match URL",
    message: `${path}`,
    consoleProps: () => {
      return {
        URL: url
      }
    }
  })
  return cy.url().should(chainer, url)
})

Cypress.Commands.add("printA11y", (context = null, ...options) => {
  var opts = options || {}
  opts.runOnly = {
    type: "tag",
    values: ["wcag2a"]
    //values: ["wcag2a", "wcag2aa"]
  }
  return cy.checkA11y(context, opts, terminalLog)
})

Cypress.Commands.add("testA11y", (url, context = null, ...options) => {
  Cypress.log({
    name: "Test A11y",
    message: `${url}`,
    consoleProps: () => {
      return {
        URL: url,
        Context: context,
        Options: options
      }
    }
  })
  cy.visit(url)
  cy.injectAxe()
  cy.printA11y(context, options || {})
})
