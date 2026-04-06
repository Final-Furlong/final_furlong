module Racing
  class Claim < ApplicationRecord
    belongs_to :entry, class_name: "Racing::RaceEntry", inverse_of: :claims
    belongs_to :claimer, class_name: "Account::Stable", inverse_of: :claims
    belongs_to :owner, class_name: "Account::Stable", inverse_of: :pending_claims

    validates :race_date, presence: true
  end
end

# == Schema Information
#
# Table name: claims
# Database name: primary
#
#  id         :bigint           not null, primary key
#  race_date  :date             not null, uniquely indexed => [claimer_id], indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  claimer_id :bigint           not null, uniquely indexed => [race_date]
#  entry_id   :bigint           not null, indexed
#  owner_id   :bigint           not null
#
# Indexes
#
#  index_claims_on_claimer_id_and_race_date  (claimer_id,race_date) UNIQUE
#  index_claims_on_entry_id                  (entry_id)
#  index_claims_on_race_date                 (race_date)
#
# Foreign Keys
#
#  fk_rails_...  (claimer_id => stables.id)
#  fk_rails_...  (entry_id => race_entries.id)
#  fk_rails_...  (owner_id => stables.id)
#

