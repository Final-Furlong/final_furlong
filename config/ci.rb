# Run using bin/ci

CI.run do
  external_ci = ENV.fetch("EXTERNAL_CI", false)
  if external_ci
    step "Setup", "bin/rails assets:precompile"
  else
    step "Setup", "bin/setup test"
  end

  limited_ci = ENV.fetch("LIMITED_CI", false)
  unless limited_ci
    step "Style: Ruby", "bundle exec rubocop"
    step "Style: Slim", "SLIM_LINT_RUBOCOP_CONF=.rubocop_slim.yml bundle exec slim-lint"
    step "Style: ESLint", "yarn eslint app/javascript"
    step "Style: StyleLint", "yarn run stylelint app/assets/tailwind"
    step "Style: I18n", "bin/i18n-tasks health"
    step "Style: Github Workflow", "actionlint" unless external_ci
  end

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: Importmap vulnerability audit", "bin/importmap audit"
  step "Security: Yarn vulnerability audit", "bin/yarn_audit.sh"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  unless limited_ci
    step "Performance: Fasterer", "bin/fasterer"
    step "Performance: Active Record Doctor", "bundle exec rake active_record_doctor"
  end

  unless limited_ci
    step "Tests: Rails", "bin/rspec"
    step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
  end

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  unless external_ci || limited_ci
    if success?
      step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
    else
      failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
    end
  end
end

