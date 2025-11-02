FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Location_#{n}" }
    state { Faker::Address.state }
    country { Faker::Address.country }
  end
end

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  country    :string           not null, uniquely indexed => [name]
#  county     :string
#  name       :string           not null, uniquely indexed => [country], indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :uuid             indexed
#
# Indexes
#
#  index_locations_on_country_and_name  (country,name) UNIQUE
#  index_locations_on_name              (name)
#  index_locations_on_old_id            (old_id)
#

