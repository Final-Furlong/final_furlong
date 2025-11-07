FactoryBot.define do
  factory :budget, class: "Account::Budget" do
    stable
    amount { 1000 }
    balance { 10_000 }
    description { "Spent some money" }
    legacy_stable_id { stable.legacy_id }
  end
end

# == Schema Information
#
# Table name: budget_transactions
# Database name: primary
#
#  id                                                                                                                                                                                           :bigint           not null, primary key
#  activity_type(sold_horse, bought_horse, bred_mare, bred_stud, claimed_horse, entered_race, shipped_horse, race_winnings, jockey_fee, nominated_racehorse, nominated_stallion, boarded_horse) :enum             indexed
#  amount                                                                                                                                                                                       :integer          default(0), not null
#  balance                                                                                                                                                                                      :integer          default(0), not null
#  description                                                                                                                                                                                  :text             not null, indexed
#  created_at                                                                                                                                                                                   :datetime         not null
#  updated_at                                                                                                                                                                                   :datetime         not null
#  legacy_budget_id                                                                                                                                                                             :integer          default(0), indexed
#  legacy_stable_id                                                                                                                                                                             :integer          default(0), indexed
#  stable_id                                                                                                                                                                                    :bigint           not null, indexed
#
# Indexes
#
#  index_budget_transactions_on_activity_type     (activity_type)
#  index_budget_transactions_on_description       (description)
#  index_budget_transactions_on_legacy_budget_id  (legacy_budget_id)
#  index_budget_transactions_on_legacy_stable_id  (legacy_stable_id)
#  index_budget_transactions_on_old_id            (old_id)
#  index_budget_transactions_on_stable_id         (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

