# typed: false
FactoryBot.define do
  factory :stable do
    name { "#{Faker::Adjective.positive} #{Faker::Color.color_name} Stable" }
    user
  end
end

# == Schema Information
#
# Table name: stables
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           indexed
#
# Indexes
#
#  index_stables_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
