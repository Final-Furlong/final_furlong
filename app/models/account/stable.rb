module Account
  class Stable < ApplicationRecord
    include PublicIdGenerator
    include FriendlyId

    FINAL_FURLONG = "Final Furlong"

    friendly_id :slug_candidates, use: [:slugged, :finders]

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

    scope :with_name, ->(name) { where("#{arel_table.name}.name ILIKE ?", "%#{name}%") }

    def self.ransackable_attributes(_auth_object = nil)
      %w[bred_horses_count description horses_count name unborn_horses_count]
    end

    def newbie?
      created_at >= 1.year.ago
    end

    def second_year?
      created_at.between?(2.years.ago, 366.days.ago)
    end

    private

    def slug_candidates
      [
        :name,
        [:name, :public_id]
      ]
    end
  end
end

# == Schema Information
#
# Table name: stables
# Database name: primary
#
#  id                :bigint           not null, primary key
#  available_balance :bigint           default(0), indexed
#  description       :text
#  last_online_at    :datetime         indexed
#  miles_from_track  :integer          default(10), not null
#  name              :string           not null
#  slug              :string           indexed
#  total_balance     :bigint           default(0), indexed
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  legacy_id         :integer          indexed
#  old_racetrack_id  :uuid             indexed
#  public_id         :string(12)       indexed
#  racetrack_id      :bigint           indexed
#  user_id           :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_stables_on_available_balance  (available_balance)
#  index_stables_on_last_online_at     (last_online_at)
#  index_stables_on_legacy_id          (legacy_id)
#  index_stables_on_name               (lower((name)::text)) UNIQUE
#  index_stables_on_old_racetrack_id   (old_racetrack_id)
#  index_stables_on_public_id          (public_id)
#  index_stables_on_racetrack_id       (racetrack_id)
#  index_stables_on_slug               (slug)
#  index_stables_on_total_balance      (total_balance)
#  index_stables_on_user_id            (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#

