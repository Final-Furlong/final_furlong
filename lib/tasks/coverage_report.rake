namespace :coverage do
  task :report do
    require 'simplecov'
    require "simplecov_json_formatter"
    require "simplecov-cobertura"
    require "simplecov-json"
    require "simplecov-lcov"

    SimpleCov.collate Dir["coverage_unit/.resultset.json", "coverage_system/.resultset.json"], 'rails' do
      coverage_dir 'coverage'

      formatter SimpleCov::Formatter::MultiFormatter.new([
                                                           SimpleCov::Formatter::JSONFormatter,
                                                           SimpleCov::Formatter::CoberturaFormatter,
                                                           SimpleCov::Formatter::LcovFormatter
                                                         ])
    end
  end
end
