return unless Rails.env.test?

ENV["TEST_TYPE"] = "system"
ENV["COVERAGE"] = "true"
ENV["SKIP_TRUE_USER"] = "true"

# rubocop:disable Metrics/MethodLength
def create_admin
  return if User.exists?(email: "admin@example.com")

  Rails.logger.error "Creating admin: admin@example.com"
  admin = FactoryBot.create(:admin, :without_stable, email: "admin@example.com", username: "admin123")
  FactoryBot.create(:stable, user: admin)
end

def create_user
  return if User.exists?(email: "user@example.com")

  Rails.logger.error "Creating admin: user@example.com"
  user = FactoryBot.create(:user, :without_stable, email: "user@example.com", username: "user123")
  FactoryBot.create(:stable, user:)
end

def create_horses
  return if Horse.count >= 5

  Rails.logger.error "Creating horse"
  FactoryBot.create(:horse)
  Rails.logger.error "Creating stallion"
  stud = FactoryBot.create(:horse, :stallion)
  Rails.logger.error "Creating broodmare"
  mare = FactoryBot.create(:horse, :broodmare)
  Rails.logger.error "Creating yearling"
  FactoryBot.create(:horse, :weanling, sire: stud, dam: mare)
  Rails.logger.error "Creating weanling"
  FactoryBot.create(:horse, :yearling, dam: mare)
end

CypressRails.hooks.before_server_start do
  # Called once, before either the transaction or the server is started
  require "factory_bot_rails"
  require "faker"
  require "simplecov"

  create_admin
  create_user
  create_horses
end

CypressRails.hooks.after_server_start do
  # Called once, after the server is started
end

CypressRails.hooks.after_transaction_start do
  # Called after the transaction is started (at launch and after each reset)
end

CypressRails.hooks.after_state_reset do
  # Triggered after `/cypress_rails_reset_state` is called
  #   cy.request('/cypress_rails_reset_state')
end

CypressRails.hooks.before_server_stop do
  # Purge and reload the test database
  Rails.logger.error "Clearing database"
  Rails.application.load_tasks
  Rake::Task["db:test:prepare"].invoke
end
# rubocop:enable Metrics/MethodLength

