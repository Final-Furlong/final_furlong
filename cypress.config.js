const { defineConfig } = require("cypress")
const fs = require("fs")

module.exports = defineConfig({
  projectId: "v7dgho",
  downloadsFolder: "tmp/cypress_downloads",
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false,
  video: true,
  videoCompression: 32,
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

      on("task", {
        log(message) {
          console.log(message)

          return null
        },
        table(message) {
          console.table(message)

          return null
        }
      })

      on("after:spec", (spec, results) => {
        if (results && results.video) {
          // Do we have failures for any retry attempts?
          const failures = results.tests.some(test => test.attempts.some(attempt => attempt.state === "failed"))
          if (!failures) {
            // delete the video if the spec passed and no tests retried
            fs.unlinkSync(results.video)
          }
        }
      })

      if (config.isTextTerminal) {
        // skip the all.cy.js specs in "cypress run" mode
        config.excludeSpecPattern = ["spec/cypress/integration/**/all.cy.js"]
      }
      return config
    }
  }
})
