require "simplecov-cobertura"
require "simplecov-json"
require "simplecov-lcov"
require "simplecov_json_formatter"

SimpleCov.start do
  load_profile "test_frameworks"

  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter "helpers"
  add_filter "models/legacy_"
  add_filter "services/migrate_legacy_"
  add_filter(%r{^/spec/})
  add_filter(%r{^/test/})

  add_group "API", "app/controllers/api"
  add_group "Controllers", "app/controllers"
  add_group "DB", %w[app/models app/repositories app/queries]
  add_group "Policies", "app/policies"
  add_group "Forms", "app/forms"
  add_group "Jobs", %w[app/jobs app/workers]
  add_group "Mailers", "app/mailers"
  add_group "Operations", %w[app/interactions app/services]
  add_group "Libraries", %w[lib/ app/validation/final_furlong]
  add_group "View Components", "app/components"

  track_files "{app,lib}/**/*.rb"

  enable_coverage(:branch)
  primary_coverage :line

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  if ENV["CI"]
    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::JSONFormatter,
        SimpleCov::Formatter::CoberturaFormatter,
        SimpleCov::Formatter::LcovFormatter
      ]
    )
  else
    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::LcovFormatter
      ]
    )
  end
end
