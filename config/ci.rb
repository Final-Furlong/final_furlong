# Run using bin/ci

CI.run do
  external_ci = ENV.fetch("EXTERNAL_CI", false)
  limited_ci = ENV.fetch("LIMITED_CI", false)
  ci_type = ENV.fetch("CI_TYPE", "all")

  unless limited_ci || %w[security performance].include?(ci_type)
    step "Setup", external_ci ? "bin/rails assets:precompile" : "bin/setup test"
  end

  if ci_type == "style" || ci_type == "all"
    step "Style: Ruby", "bundle exec rubocop"
    step "Style: Slim", "SLIM_LINT_RUBOCOP_CONF=.rubocop_slim.yml bundle exec slim-lint"
    step "Style: JS", "pnpm biome ci app/javascript"
    step "Style: CSS", "pnpm biome ci app/assets"
    step "Style: I18n", "bin/i18n-tasks health"
  end

  if ci_type == "security" || ci_type == "all"
    step "Security: Gem audit", "bin/bundler-audit"
    step "Security: PNPM vulnerability audit", "pnpm audit --ignore-unfixable --prod"
    step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  end

  if ci_type == "performance" || ci_type == "all"
    step "Performance: Fasterer", "bin/fasterer"
    step "Performance: Active Record Doctor", "bundle exec rake active_record_doctor"
  end

  if ci_type == "tests" || ci_type == "all"
    step "Tests: Setup", "pnpm install playwright --with-deps chromium && pnpm run playwright --with-deps chromium" if external_ci
    step "Tests: Rails", external_ci ? "bin/rspec --format RspecJunitFormatter --out report.xml --format progress" : "bin/rspec"
    step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant" unless external_ci
  end

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  unless external_ci
    if success?
      step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
    else
      failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
    end
  end
end

