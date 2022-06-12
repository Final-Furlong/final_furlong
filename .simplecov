require "simplecov-json"
require "simplecov-lcov"

SimpleCov.start "rails" do
  add_filter(%r{^/sorbet/})
  add_filter(%r{^/spec/})
  add_filter(%r{^/test/})

  add_group "View Components", "app/components"

  enable_coverage(:branch)
  primary_coverage :branch

  track_files "**/*.rb"

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]
  )
end
