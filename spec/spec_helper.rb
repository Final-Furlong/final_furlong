# typed: false
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require "simplecov"
require "simplecov-json"
require "simplecov-lcov"
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.start "rails" do
  add_filter(%r{^/spec/})
  add_filter(%r{^/test/})
  enable_coverage(:branch)
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]
  )
end
require "undercover"

require "capybara/rspec"
require "faker"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  #   if config.files_to_run.one?
  #     # Use the documentation formatter for detailed output,
  #     # unless a formatter has already been configured
  #     # (e.g. via a command-line flag).
  #     config.default_formatter = "doc"
  #   end

  config.profile_examples = 10 if ENV.fetch("CI", false)

  config.order = :random

  Kernel.srand config.seed
end
