module Account
  class Stable < ApplicationRecord
    FINAL_FURLONG = "Final Furlong"

    attribute :miles_from_track, default: -> { 10 }

    belongs_to :user
    belongs_to :racetrack, class_name: "Racing::Racetrack", optional: true

    has_many :bred_horses, class_name: "Horses::Horse", foreign_key: :breeder_id, inverse_of: :breeder,
      dependent: :restrict_with_exception
    has_many :horses, class_name: "Horses::Horse", foreign_key: :owner_id, inverse_of: :owner,
      dependent: :restrict_with_exception
    has_many :training_schedules, class_name: "Racing::TrainingSchedule", inverse_of: :stable,
      dependent: :restrict_with_exception
    has_many :auctions, class_name: "Auction", inverse_of: :auctioneer, dependent: :restrict_with_exception
    has_many :auction_bids, class_name: "Auctions::Bid", inverse_of: :bidder, dependent: :destroy

    validates :name, :miles_from_track, presence: true
    validates :name, uniqueness: { case_sensitive: false }

    def self.ransackable_attributes(_auth_object = nil)
      %w[bred_horses_count description horses_count name unborn_horses_count]
    end

    def newbie?
      created_at >= 1.year.ago
    end

    def second_year?
      created_at.between?(2.years.ago, 366.days.ago)
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
#  miles_from_track    :integer          default(10), not null
#  name                :string           not null
#  total_balance       :integer          default(0)
#  unborn_horses_count :integer          default(0), not null
#  created_at          :datetime         not null, indexed
#  updated_at          :datetime         not null
#  legacy_id           :integer          indexed
#  racetrack_id        :uuid             indexed
#  user_id             :uuid             not null, uniquely indexed
#
# Indexes
#
#  index_stables_on_created_at      (created_at)
#  index_stables_on_last_online_at  (last_online_at)
#  index_stables_on_legacy_id       (legacy_id)
#  index_stables_on_name            (lower((name)::text)) UNIQUE
#  index_stables_on_racetrack_id    (racetrack_id)
#  index_stables_on_user_id         (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id)
#  fk_rails_...  (user_id => users.id)
#

