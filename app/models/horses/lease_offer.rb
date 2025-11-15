module Horses
  class LeaseOffer < ApplicationRecord
    RACEHORSE_MIN_MONTHS = 3
    NON_RACEHORSE_MIN_MONTHS = 12
    MAX_MONTHS = 12
    MAX_OFFER_PERIOD_DAYS = 60

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :leaser, class_name: "Account::Stable", optional: true

    validates :offer_start_date, :duration_months, :fee, presence: true
    validates :offer_start_date, comparison: { greater_than_or_equal_to: :minimum_offer_date }
    validates :offer_start_date, comparison: { less_than_or_equal_to: :maximum_offer_date }
    validates :duration_months, comparison: { greater_than_or_equal_to: :minimum_months, less_than_or_equal_to: MAX_MONTHS }, unless: :non_racehorse?
    validates :duration_months, numericality: { only_integer: true, equal_to: :minimum_months }, if: :non_racehorse?
    validates :new_members_only, inclusion: { in: [true, false] }
    validates :new_members_only, inclusion: { in: [false] }, if: :leaser

    # rubocop:disable Rails/WhereEquals
    scope :active, -> { where(offer_start_date: ..Date.current) }
    scope :expired, -> { where(offer_start_date: ..(Date.current - (MAX_OFFER_PERIOD_DAYS + 1).days)) }
    scope :starts_today, -> { where(offer_start_date: Date.current) }
    scope :with_leaser, -> { where.not(leaser_id: nil) }

    scope :leased_to, ->(stable) {
      where("lease_offers.leaser_id = :id", id: stable.id)
    }
    scope :with_owner, ->(owner) { where(owner:) }
    scope :without_owner, ->(owner) { where.not(owner:) }
    scope :new_members_only, -> { where("lease_offers.leaser_id IS NULL") }
    scope :non_new_members_only, -> {
      where("lease_offers.leaser_id IS NULL AND lease_offers.new_members_only = FALSE")
    }
    scope :valid_for_stable, ->(stable) {
      if stable.newbie?
        active.new_members_only.without_owner(stable)
          .or(active.without_owner(stable).leased_to(stable))
      else
        active.non_new_members_only.without_owner(stable)
          .or(active.without_owner(stable).leased_to(stable))
      end
    }
    # rubocop:enable Rails/WhereEquals

    def maximum_offer_date
      Date.current + MAX_OFFER_PERIOD_DAYS.days
    end

    def minimum_offer_date
      horse&.racehorse? ? Date.current : Game::BreedingSeason.next_season_start_date - MAX_OFFER_PERIOD_DAYS.days
    end

    def minimum_months
      horse&.racehorse? ? RACEHORSE_MIN_MONTHS : NON_RACEHORSE_MIN_MONTHS
    end

    def options_for_duration_select
      (minimum_months..MAX_MONTHS).each do |month|
        [month, month]
      end
    end

    private

    def non_racehorse?
      return false unless horse

      !horse.racehorse?
    end
  end
end

# == Schema Information
#
# Table name: lease_offers
# Database name: primary
#
#  id               :bigint           not null, primary key
#  duration_months  :integer          not null
#  fee              :integer          default(0), not null
#  new_members_only :boolean          default(FALSE), not null
#  offer_start_date :date             not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  horse_id         :bigint           not null, uniquely indexed
#  leaser_id        :bigint           indexed
#  owner_id         :bigint           not null, indexed
#
# Indexes
#
#  index_lease_offers_on_horse_id          (horse_id) UNIQUE
#  index_lease_offers_on_leaser_id         (leaser_id)
#  index_lease_offers_on_offer_start_date  (offer_start_date)
#  index_lease_offers_on_owner_id          (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (owner_id => stables.id)
#

