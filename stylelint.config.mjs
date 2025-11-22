/** @type {import("stylelint").Config} */
export default {
  extends: ["stylelint-config-standard", "stylelint-config-prettier", "stylelint-config-tailwindcss/scss"],
  plugins: ["stylelint-order", "stylelint-prettier"],
  ignoreFiles: ["/**/assets/vendor/stylesheets/*.css", "/**/assets/stylesheets/*.css", "**/coverage/assets/**/*.css"],
  rules: {
    "at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: ["tailwind", "apply", "variants", "responsive", "screen"]
      }
    ]
  }
}
