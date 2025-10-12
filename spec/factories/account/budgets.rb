FactoryBot.define do
  factory :budget, class: "Account::Budget" do
    stable
    amount { 1000 }
    balance { 10_000 }
    description { "Spent some money" }
    legacy_budget_id { rand(1..999_999) }
    legacy_stable_id { stable.legacy_id }
  end
end

# == Schema Information
#
# Table name: budgets
#
#  id               :uuid             not null, primary key
#  amount           :integer          default(0), not null
#  balance          :integer          default(0), not null
#  description      :text             not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  legacy_budget_id :integer          default(0), indexed
#  legacy_stable_id :integer          default(0), indexed
#  stable_id        :uuid             not null, indexed
#
# Indexes
#
#  index_budgets_on_description       (description)
#  index_budgets_on_legacy_budget_id  (legacy_budget_id)
#  index_budgets_on_legacy_stable_id  (legacy_stable_id)
#  index_budgets_on_stable_id         (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id)
#

