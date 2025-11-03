module Account
  class Budget < ApplicationRecord
    self.table_name = "budget_transactions"

    belongs_to :stable

    validates :amount, :balance, :description, presence: true
    validates :amount, :balance, numericality: { only_integer: true }

    scope :recent, -> { order(created_at: :desc) }

    def self.create_new(stable:, description:, amount:, date: nil, legacy_budget_id: nil, legacy_stable_id: nil)
      previous_budget = where(stable:).recent.last
      attrs = {
        stable:,
        description:,
        amount:,
        balance: (previous_budget&.balance || 0) + amount
      }
      attrs[:created_at] = date if date.present?
      attrs[:legacy_budget_id] = legacy_budget_id if legacy_budget_id.present?
      attrs[:legacy_stable_id] = legacy_stable_id if legacy_stable_id.present?
      create!(attrs)
    end
  end
end

# == Schema Information
#
# Table name: budget_transactions
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

