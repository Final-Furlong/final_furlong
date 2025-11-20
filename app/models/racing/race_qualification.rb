module Racing
  class RaceQualification < ApplicationRecord
    self.table_name = "race_qualifications"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_qualification

    scope :by_horse, ->(id) { where(horse_id: id) }
    scope :qualified_for, ->(type) { where("#{type}_qualified": true) }
    scope :not_qualified_for, ->(type) { where("#{type}_qualified": false) }

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end
  end
end

# == Schema Information
#
# Table name: race_qualifications
# Database name: primary
#
#  allowance_placed            :boolean
#  claiming_qualified          :boolean
#  maiden_qualified            :boolean
#  nw1_allowance_qualified     :boolean
#  nw2_allowance_qualified     :boolean
#  nw3_allowance_qualified     :boolean
#  stakes_placed               :boolean
#  starter_allowance_qualified :boolean
#  horse_id                    :bigint           primary key
#

