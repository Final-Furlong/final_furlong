module Auctions
  class ConsignmentConfig < ApplicationRecord
    self.table_name = "auction_consignment_configs"

    HORSE_TYPES = %w[racehorse stud broodmare yearling weanling].freeze

    belongs_to :auction, class_name: "::Auction"

    validates :horse_type, :minimum_age, :maximum_age, :minimum_count, presence: true
    validates :horse_type, uniqueness: { case_sensitive: false, scope: :auction_id }
    validates :horse_type, inclusion: { in: HORSE_TYPES }
    validates :minimum_age, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 3 }, if: :racehorse?
    validates :maximum_age, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 5 }, if: :racehorse?
    validates :minimum_age, numericality: { greater_than_or_equal_to: 4, less_than_or_equal_to: 12 }, if: :stallion?
    validates :maximum_age, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 15 }, if: :stallion?
    validates :minimum_age, numericality: { greater_than_or_equal_to: 4, less_than_or_equal_to: 12 }, if: :broodmare?
    validates :maximum_age, numericality: { greater_than_or_equal_to: 5, less_than_or_equal_to: 15 }, if: :broodmare?
    validates :minimum_age, numericality: { equal_to: 1 }, if: :yearling?
    validates :maximum_age, numericality: { equal_to: 1 }, if: :yearling?
    validates :minimum_age, numericality: { equal_to: 0 }, if: :weanling?
    validates :maximum_age, numericality: { equal_to: 0 }, if: :weanling?
    validates :maximum_age, comparison: { greater_than_or_equal_to: :minimum_age }
    validates :minimum_count, numericality: { greater_than: 0 }
    validates :stakes_quality, inclusion: { in: [true, false] }

    def racehorse?
      horse_type.to_s.casecmp("racehorse").zero?
    end

    def stallion?
      horse_type.to_s.casecmp("stallion").zero?
    end

    def broodmare?
      horse_type.to_s.casecmp("broodmare").zero?
    end

    def yearling?
      horse_type.to_s.casecmp("yearling").zero?
    end

    def weanling?
      horse_type.to_s.casecmp("weanling").zero?
    end
  end
end

# == Schema Information
#
# Table name: auction_consignment_configs
#
#  id             :bigint           not null, primary key
#  horse_type     :string           not null
#  maximum_age    :integer          default(0), not null
#  minimum_age    :integer          default(0), not null
#  minimum_count  :integer          default(0), not null
#  stakes_quality :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  auction_id     :integer          indexed
#  old_auction_id :uuid             not null, indexed
#  old_id         :uuid             indexed
#
# Indexes
#
#  index_auction_consignment_configs_on_auction_id      (auction_id)
#  index_auction_consignment_configs_on_old_auction_id  (old_auction_id)
#  index_auction_consignment_configs_on_old_id          (old_id)
#
# Foreign Keys
#
#  fk_rails_...  (auction_id => auctions.id) ON DELETE => cascade ON UPDATE => cascade
#

