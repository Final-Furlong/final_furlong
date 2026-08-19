module Horses
  class BreedingStats < ApplicationRecord
    self.ignored_columns += ["soundness", "allele"]

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :breeding_stats

    validates :breeding_potential, :breeding_potential_grandparent, presence: true
  end
end

# == Schema Information
#
# Table name: breeding_stats
# Database name: primary
#
#  id                             :bigint           not null, primary key
#  breeding_potential             :integer          default(0), not null
#  breeding_potential_grandparent :integer          default(0), not null
#  dosage                         :string           indexed
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  horse_id                       :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_breeding_stats_on_dosage    (dosage)
#  index_breeding_stats_on_horse_id  (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

