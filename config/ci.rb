# Run using bin/ci

CI.run do
  unless ENV.fetch("EXTERNAL_CI", false)
    step "Setup", "bin/setup test"
  end

  step "Style: Ruby", "bundle exec rubocop"
  step "Style: Slim", "SLIM_LINT_RUBOCOP_CONF=.rubocop_slim.yml bundle exec slim-lint"
  step "Style: ESLint", "yarn eslint app/javascript"
  step "Style: StyleLint", "yarn run stylelint app/assets/tailwind"
  step "Style: I18n", "bin/i18n-tasks health"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Yarn vulnerability audit", "bin/yarn_audit.sh"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  step "Performance: Fasterer", "bin/fasterer"
  step "Performance: Active Record Doctor", "bundle exec rake active_record_doctor"

  step "Tests: Rails", "bin/rspec"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  unless ENV.fetch("EXTERNAL_CI", false)
    if success?
      step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
    else
      failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
    end
  end
end

