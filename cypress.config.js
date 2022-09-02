const { defineConfig } = require("cypress")

module.exports = defineConfig({
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false,
  video: false,
  fixturesFolder: "spec/cypress/fixtures",

  e2e: {
    specPattern: "spec/cypress/integration/**/*.cy.{js,jsx,ts,tsx}",
    excludeSpecPattern: process.env.CI ? ["cypress/integration/**/all.cy.js"] : [],
    supportFile: "spec/cypress/support/integration.{js,jsx,ts,tsx}",
    setupNodeEvents(_on, config) {
      if (config.isTextTerminal) {
        // skip the all.cy.js specs in "cypress run" mode
        return {
          excludeSpecPattern: ["spec/cypress/integration/**/all.cy.js"]
        }
      }
    }
  }
})
