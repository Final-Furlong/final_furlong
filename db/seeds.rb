# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"
require "factory_bot_rails"
max_users = 5
user_count = max_users - User.count
puts "Creating #{user_count} user(s)"
FactoryBot.create_list(:user, user_count, :with_stable) if user_count.positive?
if Rails.env.development?
  puts "Creating admin"
  admin_email = "admin@example.com"
  admin = if User.exists?(email: admin_email)
            User.find_by(email: admin_email)
          else
            FactoryBot.create(:admin, :with_stable, email: admin_email,
                                                    password: "password", password_confirmation: "password")
          end
  FactoryBot.create(:stable, user: admin) unless admin.reload.stable
  puts "Creating horse"
  FactoryBot.create(:horse)
  puts "Creating stud"
  stud = FactoryBot.create(:horse, :stallion)
  puts "Creating mare"
  mare = FactoryBot.create(:horse, :broodmare)
  puts "Creating yearling"
  FactoryBot.create(:horse, :weanling, sire: stud, dam: mare)
  puts "Creating weanling"
  FactoryBot.create(:horse, :yearling, dam: mare)
end
