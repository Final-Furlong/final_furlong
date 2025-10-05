FactoryBot.define do
  factory :legacy_stable, class: "Legacy::Stable" do
    id { Faker::Number.number(digits: 5) }
    availableBalance { 10_000 }
    date { Date.current }
    totalBalance { 20_000 }
  end
end

# == Schema Information
#
# Table name: ff_stables
#
#  id               :integer          not null, primary key
#  availableBalance :integer          default(0)
#  date             :datetime         not null
#  slug             :string(255)
#  totalBalance     :integer          default(0)
#

