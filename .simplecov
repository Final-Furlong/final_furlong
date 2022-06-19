require "simplecov-cobertura"
require "simplecov-json"
require "simplecov-lcov"
require "simplecov_json_formatter"

SimpleCov.start "rails" do
  add_filter(%r{^/sorbet/})
  add_filter(%r{^/spec/})
  add_filter(%r{^/test/})

  add_group "View Components", "app/components"

  enable_coverage(:branch)
  primary_coverage :line

  track_files "**/*.rb"

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
