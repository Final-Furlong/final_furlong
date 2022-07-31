# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

Rails.application.load_tasks

desc "Alphabetise database schema columns"
task "db::dump": "strong_migrations:alphabetize_columns"
