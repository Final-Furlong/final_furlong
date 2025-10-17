FactoryBot.define do
  factory :activity, class: "Account::Activity" do
    stable
    activity_type { "buying" }
    amount { 10 }
    balance { 10 }
    legacy_stable_id { stable.legacy_id || 10 }
  end
end

# == Schema Information
#
# Table name: budgets
#
#  id               :uuid             not null, primary key
#  amount           :bigint           default(0), not null
#  balance          :bigint           default(0), not null
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

