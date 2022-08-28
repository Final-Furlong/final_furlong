const { defineConfig } = require("cypress")

module.exports = defineConfig({
  screenshotsFolder: "tmp/cypress_screenshots",
  videosFolder: "tmp/cypress_videos",
  trashAssetsBeforeRuns: false,
  videos: false,

  e2e: {
    // setupNodeEvents(on, config) {}
  }
})
