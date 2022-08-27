require "simplecov_json_formatter"
require "simplecov-cobertura"
require "simplecov-json"
require "simplecov-lcov"

SimpleCov.profiles.define 'common' do
  load_profile "test_frameworks"

  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter "lib/generators"
  add_filter "lib/tasks"
  add_filter "models/legacy_"
  add_filter "services/migrate_legacy_"
  add_filter(%r{^/spec/})
  add_filter(%r{^/test/})

  track_files "{app,lib}/**/*.rb"

  enable_coverage(:branch)
  primary_coverage :line

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end
end

SimpleCov.profiles.define 'ci' do
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::JSONFormatter,
      SimpleCov::Formatter::CoberturaFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]
  )
end

SimpleCov.profiles.define 'local' do
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::SimpleFormatter,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]
  )
end

SimpleCov.profiles.define 'unit' do
  coverage_dir 'coverage_unit'

  minimum_coverage line: 47.3, branch: 73.9
  # minimum_coverage_by_file line: 10, branch: 10

  add_filter "app/controllers"

  add_group "API", "app/controllers/api"
  add_group "DB", %w[app/models app/repositories app/queries]
  add_group "Policies", "app/policies"
  add_group "Forms", "app/forms"
  add_group "Jobs", %w[app/jobs app/workers]
  add_group "Mailers", "app/mailers"
  add_group "Operations", %w[app/interactions app/services]
  add_group "Lib", %w[lib/ app/validation/final_furlong]
  add_group "View Components", "app/frontend/components"
end

SimpleCov.profiles.define 'system' do
  coverage_dir 'coverage_system'

  minimum_coverage line: 42.2, branch: 14
  # minimum_coverage_by_file line: 10, branch: 10

  add_group "API", "app/controllers/api"
  add_group "Controllers", "app/controllers"
  add_group "DB", %w[app/models app/repositories app/queries]
  add_group "Policies", "app/policies"
  add_group "Forms", "app/forms"
  add_group "Jobs", %w[app/jobs app/workers]
  add_group "Mailers", "app/mailers"
  add_group "Operations", %w[app/interactions app/services]
  add_group "Lib", %w[lib/ app/validation/final_furlong]
  add_group "View Components", "app/frontend/components"
end

SimpleCov.profiles.define "default" do
  coverage_dir "coverage"

  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter "helpers"
  add_filter "lib/generators"
  add_filter "lib/tasks"
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
  add_group "Lib", %w[lib/ app/validation/final_furlong]
  add_group "View Components", "app/frontend/components"
end

SimpleCov.start do
  load_profile "common"
  load_profile "test_frameworks"

  env_test_type = ENV.fetch('TEST_TYPE', nil)
  arg_test_types = ARGV.select { |arg| arg.start_with?('type:') }.map { |arg| arg.gsub('type:', '') }
  if env_test_type == 'unit' || arg_test_types.include?('~system')
    load_profile "unit"
  elsif env_test_type == 'system' || arg_test_types.include?('system')
    load_profile "system"
  else
    load_profile "default"
  end

  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = "coverage/lcov.info"
  end

  if ENV["CI"]
    load_profile 'ci'
  else
    load_profile 'local'
  end
end
