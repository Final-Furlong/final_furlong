module Account
  class Budget < ApplicationRecord
    belongs_to :stable

    validates :amount, :balance, :description, presence: true
    validates :amount, :balance, numericality: { only_integer: true }

    scope :recent, -> { order(id: :desc) }

    def self.create_new(stable:, description:, amount:, date: nil, legacy_budget_id: nil, legacy_stable_id: nil)
      previous_budget = where(stable:).recent.first
      attrs = {
        stable:,
        description:,
        amount:,
        balance: previous_budget&.balance.to_i + amount
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

