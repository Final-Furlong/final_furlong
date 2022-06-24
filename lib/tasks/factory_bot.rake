namespace :factory_bot do
  desc "Verify that all FactoryBot factories are valid"
  task lint: :environment do
    if Rails.env.test?
      require "factory_bot-awesome_linter"
      require "faker"
      abort unless FactoryBot::AwesomeLinter.lint!
    else
      puts "Wrong environment detected to run factory_bot:lint"
      puts "Running `bundle exec bin/rails factory_bot:lint RAILS_ENV='test'` instead"

      system("bundle exec bin/rails factory_bot:lint RAILS_ENV='test'")
      exit $CHILD_STATUS.exitstatus
    end
  end
end
