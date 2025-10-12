module Account
  class Stable < ApplicationRecord
    FINAL_FURLONG = "Final Furlong"

    belongs_to :user

    has_many :bred_horses, class_name: "Horses::Horse", foreign_key: :breeder_id, inverse_of: :breeder,
      dependent: :restrict_with_exception
    has_many :horses, class_name: "Horses::Horse", foreign_key: :owner_id, inverse_of: :owner,
      dependent: :restrict_with_exception
    has_many :training_schedules, class_name: "Racing::TrainingSchedule", inverse_of: :stable,
      dependent: :restrict_with_exception
    has_many :auctions, class_name: "Auction", inverse_of: :auctioneer, dependent: :restrict_with_exception
    has_many :auction_bids, class_name: "Auctions::Bid", inverse_of: :bidder, dependent: :destroy

    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    def self.ransackable_attributes(_auth_object = nil)
      %w[bred_horses_count description horses_count name unborn_horses_count]
    end

    def newbie?
      created_at >= 1.year.ago
    end

    def second_year?
      created_at.between?(366.days.ago, 2.years.ago)
    end
  end
end

# == Schema Information
#
# Table name: stables
#
#  id                  :uuid             not null, primary key
#  available_balance   :integer          default(0)
#  bred_horses_count   :integer          default(0), not null
#  description         :text
#  horses_count        :integer          default(0), not null
#  last_online_at      :datetime         indexed
#  name                :string           not null
#  total_balance       :integer          default(0)
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
#  index_stables_on_name            (lower((name)::text)) UNIQUE
#  index_stables_on_user_id         (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

