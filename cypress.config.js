const { defineConfig } = require("cypress")

module.exports = defineConfig({
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false,
  video: false,
  fixturesFolder: "spec/cypress/fixtures",

  e2e: {
    env: {
      // list the files and file patterns to watch
      "cypress-watch-and-reload": {
        watch: ["app/*", "Gemfile.lock"]
      }
    },
    specPattern: "spec/cypress/integration/**/*.cy.{js,jsx,ts,tsx}",
    excludeSpecPattern: process.env.CI ? ["cypress/integration/**/all.cy.js"] : [],
    supportFile: "spec/cypress/support/integration.{js,jsx,ts,tsx}",
    setupNodeEvents(on, config) {
      require("cypress-fail-fast/plugin")(on, config)
      require("cypress-watch-and-reload/plugins")(on, config)

      if (config.isTextTerminal) {
        // skip the all.cy.js specs in "cypress run" mode
        config.excludeSpecPattern = ["spec/cypress/integration/**/all.cy.js"]
      }
      return config
    }
  }
})
