module Horses
  class Lease < ApplicationRecord
    RACEHORSE_TIME = 3.months
    NON_RACEHORSE_TIME = 1.year

    belongs_to :horse, class_name: "Horse"
    belongs_to :owner, class_name: "Account::Stable"
    belongs_to :leaser, class_name: "Account::Stable"

    has_one :termination_request, class_name: "LeaseTerminationRequest", inverse_of: :lease, dependent: :delete

    validates :start_date, :end_date, :fee, presence: true
    validates :active, inclusion: { in: [true, false] }
    validates :end_date, comparison: { greater_than_or_equal_to: :start_date_plus_minimum_duration }, if: -> { start_date && horse }
    validates :end_date, comparison: { less_than_or_equal_to: :start_date_plus_maximum_duration }, if: :start_date

    def total_days
      (end_date - start_date).to_i
    end

    private

    def start_date_plus_minimum_duration
      minimum_time = horse.racehorse? ? RACEHORSE_TIME : NON_RACEHORSE_TIME
      start_date + minimum_time
    end

    def start_date_plus_maximum_duration
      start_date + 1.year
    end
  end
end

# == Schema Information
#
# Table name: leases
# Database name: primary
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE), not null, indexed
#  early_termination_date :date             indexed
#  end_date               :date             not null, indexed
#  fee                    :integer          default(0), not null
#  start_date             :date             not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  horse_id               :bigint           not null, uniquely indexed
#  leaser_id              :bigint           not null, indexed
#  owner_id               :bigint           not null, indexed
#
# Indexes
#
#  index_leases_on_active                  (active)
#  index_leases_on_early_termination_date  (early_termination_date)
#  index_leases_on_end_date                (end_date)
#  index_leases_on_horse_id                (horse_id) UNIQUE WHERE (active = true)
#  index_leases_on_leaser_id               (leaser_id)
#  index_leases_on_owner_id                (owner_id)
#  index_leases_on_start_date              (start_date)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (leaser_id => stables.id)
#  fk_rails_...  (owner_id => stables.id)
#

