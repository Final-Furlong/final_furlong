const { defineConfig } = require("cypress")

module.exports = defineConfig({
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false,
  video: false,
  fixturesFolder: "spec/cypress/fixtures",

  e2e: {
    specPattern: "spec/cypress/integration/**/*.cy.{js,jsx,ts,tsx}",
    supportFile: "spec/cypress/support/integration.{js,jsx,ts,tsx}"
    // setupNodeEvents(on, config) {}
  }
})
