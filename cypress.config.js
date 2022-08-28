const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:5017',
    defaultCommandTimeout: 10000,
    supportFile: 'spec/cypress/support/index.js',
    specPattern: 'spec/cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
  }
})
