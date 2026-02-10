module Racing
  class RaceQualification < ApplicationRecord
    self.table_name = "race_qualifications"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_qualification

    scope :by_horse, ->(id) { where(horse_id: id) }
    scope :qualified_for, ->(type) {
      if Config::Racing.non_qualified_types.include?(type)
        not_qualified_for(previous_qualification_level(type))
      elsif type.to_s == "maiden"
        where("#{type}_qualified": true)
      else
        query = where("#{type}_qualified": true)
        previous_qualification_levels(type).each do |qual_type|
          query = query.not_qualified_for(qual_type)
        end
        query
      end
    }
    scope :qualified_for_exactly, ->(type) { where("#{type}_qualified": true) }
    scope :not_qualified_for, ->(type) { where("#{type}_qualified": false) }

    def self.previous_qualification_level(qualification)
      if Config::Racing.non_qualified_types.include?(qualification)
        :nw3_allowance
      elsif qualification.to_sym == :maiden
        :none
      else
        types = Config::Racing.qualified_types
        types.slice(0, types.find_index(qualification) - 1)
      end
    end

    def self.previous_qualification_levels(qualification)
      qualification = "allowance" if qualification == "stakes"
      if qualification.to_sym == :maiden
        []
      else
        types = Config::Racing.claiming_types.include?(qualification) ? Config::Racing.all_types : Config::Racing.qualified_types
        types.slice(0, types.find_index(qualification))
      end
    end

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
#  horse_id                    :bigint           primary key, uniquely indexed
#
# Indexes
#
#  index_race_qualifications_on_horse_id  (horse_id) UNIQUE
#

