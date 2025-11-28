module Account
  class Activity < ApplicationRecord
    self.table_name = "activity_points"

    belongs_to :stable
    belongs_to :budget, optional: true

    validates :activity_type, :amount, :balance, :legacy_stable_id, presence: true
    validates :activity_type, inclusion: { in: Config::Game.activity_types }

    scope :recent, -> { order(created_at: :desc) }
  end
end

# == Schema Information
#
# Table name: activity_points
# Database name: primary
#
#  id                                                                                       :bigint           not null, primary key
#  activity_type(color_war, auction, selling, buying, breeding, claiming, entering, redeem) :enum             not null, indexed
#  amount                                                                                   :integer          default(0), not null
#  balance                                                                                  :bigint           default(0), not null
#  created_at                                                                               :datetime         not null
#  updated_at                                                                               :datetime         not null
#  budget_id                                                                                :bigint           indexed
#  legacy_stable_id                                                                         :integer          default(0), not null, indexed
#  stable_id                                                                                :bigint           not null, indexed
#
# Indexes
#
#  index_activity_points_on_activity_type     (activity_type)
#  index_activity_points_on_budget_id         (budget_id)
#  index_activity_points_on_legacy_stable_id  (legacy_stable_id)
#  index_activity_points_on_stable_id         (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (budget_id => budget_transactions.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (stable_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

