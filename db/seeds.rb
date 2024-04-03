# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
return unless Rails.env.development?

require "faker"
require "factory_bot_rails"
max_stables = ENV.fetch("USERS", 5).to_i
stable_count = max_stables - Account::Stable.count
Rails.logger.info "Creating #{stable_count} stable(s)"
FactoryBot.create_list(:stable, stable_count) if stable_count.positive?
Rails.logger.info "Creating admin"
admin_email = "admin@example.com"
admin = if Account::User.exists?(email: admin_email)
  Account::User.find_by(email: admin_email)
else
  FactoryBot.create(:admin, :without_stable, email: admin_email, username: "admin123",
    password: "Password1!", password_confirmation: "Password1!")
end
FactoryBot.create(:stable, user: admin) unless admin.reload.stable
if Horses::Horse.count.zero?
  Rails.logger.info "Creating horse"
  FactoryBot.create(:horse)
  Rails.logger.info "Creating stud"
  stud = FactoryBot.create(:horse, :stallion)
  Rails.logger.info "Creating mare"
  mare = FactoryBot.create(:horse, :broodmare)
  Rails.logger.info "Creating yearling"
  FactoryBot.create(:horse, :yearling, :plain, dam: mare)
  Rails.logger.info "Creating weanling"
  FactoryBot.create(:horse, :weanling, sire: stud, dam: mare)
end

