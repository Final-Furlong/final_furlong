return unless Rails.env.test?

ENV["TEST_TYPE"] = "system"
ENV["COVERAGE"] = "true"

CypressRails.hooks.before_server_start do
  # Called once, before either the transaction or the server is started
  require "factory_bot_rails"
  require "faker"
  require "simplecov"
end

CypressRails.hooks.after_server_start do
  # Called once, after the server is started
  unless User.exists?(email: "admin@example.com")
    admin = FactoryBot.create(:admin, :without_stable, email: "admin@example.com", username: "admin123")
    FactoryBot.create(:stable, user: admin)
  end

  unless User.exists?(email: "user@example.com")
    user = FactoryBot.create(:user, :without_stable, email: "user@example.com", username: "user123")
    FactoryBot.create(:stable, user:)
  end

  FactoryBot.create(:horse)
  stud = FactoryBot.create(:horse, :stallion)
  mare = FactoryBot.create(:horse, :broodmare)
  FactoryBot.create(:horse, :weanling, sire: stud, dam: mare)
  FactoryBot.create(:horse, :yearling, dam: mare)
end

CypressRails.hooks.after_transaction_start do
  # Called after the transaction is started (at launch and after each reset)
end

CypressRails.hooks.after_state_reset do
  # Triggered after `/cypress_rails_reset_state` is called
end

CypressRails.hooks.before_server_stop do
  # Purge and reload the test database
  puts "Clearing database"
  Rails.application.load_tasks
  Rake::Task["db:test:prepare"].invoke
end

