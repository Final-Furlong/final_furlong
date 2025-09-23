FactoryBot.define do
  factory :stable, class: "Account::Stable" do
    name { "#{Faker::Adjective.positive} #{Faker::Color.color_name} Stable" }
    user { association :user, stable: instance }
    legacy_id { rand(1..999_999) }
  end
end

# == Schema Information
#
# Table name: stables
#
#  id                  :uuid             not null, primary key
#  bred_horses_count   :integer          default(0), not null
#  description         :text
#  horses_count        :integer          default(0), not null
#  last_online_at      :datetime         indexed
#  name                :string           not null
#  unborn_horses_count :integer          default(0), not null
#  created_at          :datetime         not null, indexed
#  updated_at          :datetime         not null
#  legacy_id           :integer          indexed
#  user_id             :uuid             not null, uniquely indexed
#
# Indexes
#
#  index_stables_on_created_at      (created_at)
#  index_stables_on_last_online_at  (last_online_at)
#  index_stables_on_legacy_id       (legacy_id)
#  index_stables_on_user_id         (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

