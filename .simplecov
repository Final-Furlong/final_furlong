require "simplecov-cobertura"
require "simplecov-lcov"

SimpleCov.profiles.define "common" do
  coverage_dir "coverage"

  cover "app/**/*.rb"

  skip "models/legacy/"
  skip "services/migrate_legacy_"

  group "API", "app/controllers/api"
  group "Controllers" do |file|
    file.filename[%r{/app/controllers}].present? && file.filename[%r{/app/controllers/api}].blank?
  end
  group "DB", %w[app/models app/repositories app/queries]
  group "Policies", "app/policies"
  group "Forms", "app/forms"
  group "Jobs", %w[app/jobs app/workers]
  group "Mailers", "app/mailers"
  group "Operations", %w[app/interactions app/services]
  group "Lib", %w[lib/ app/validation/final_furlong]
  group "View Components", "app/components"
end

SimpleCov.profiles.define "ci" do
  require "undercover/simplecov_formatter"

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::CoberturaFormatter,
      SimpleCov::Formatter::LcovFormatter,
      SimpleCov::Formatter::Undercover
    ]
  )
end

SimpleCov.profiles.define "local" do
  require "undercover/simplecov_formatter"

  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::Undercover
    ]
  )
end

SimpleCov.profiles.define "default" do
  load_profile "common"

  merge_subprocesses true
  merge_timeout 360
  enable_coverage :branch
  primary_coverage :line

  if ENV["CI"]
    load_profile "ci"
  else
    load_profile "local"
  end
end

