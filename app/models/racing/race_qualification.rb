module Racing
  class RaceQualification < ApplicationRecord
    self.table_name = "race_qualifications"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_qualification

    scope :by_horse, ->(id) { where(horse_id: id) }
    scope :qualified_for, ->(type) {
      if Config::Racing.non_qualified_types.include?(type)
        if type.to_s == "stakes"
          where(stakes_placed: true)
        else
          query = where(stakes_placed: false)
          previous_qualification_levels(type).each do |qual_type|
            query = query.not_qualified_for(qual_type)
          end
          query
        end
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
    scope :qualified_for_exactly, ->(type) {
      if Config::Racing.non_qualified_types.include?(type)
        all
      else
        where("#{type}_qualified": true)
      end
    }
    scope :not_qualified_for, ->(type) { where("#{type}_qualified": false) }
    scope :sort_by_qualified_asc, -> {
      order(Arel.sql("CASE
      WHEN (maiden_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 1
      WHEN (maiden_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 1.5
      WHEN (nw1_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 2
      WHEN (nw1_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 2.5
      WHEN (nw2_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 3
      WHEN (nw2_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 3.5
      WHEN (nw3_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 4
      WHEN (nw3_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 4.5
      WHEN starter_allowance_qualified = FALSE THEN 5
      ELSE 6
      END"))
    }
    scope :sort_by_qualified_desc, -> {
      order(Arel.sql("CASE
      WHEN (maiden_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 6.5
      WHEN (maiden_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 6
      WHEN (nw1_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 5.5
      WHEN (nw1_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 5
      WHEN (nw2_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 4.5
      WHEN (nw2_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 4
      WHEN (nw3_allowance_qualified = TRUE AND starter_allowance_qualified = FALSE) THEN 3.5
      WHEN (nw3_allowance_qualified = TRUE AND starter_allowance_qualified = TRUE) THEN 3
      WHEN starter_allowance_qualified = FALSE THEN 2
      ELSE 1
      END"))
    }

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
      if qualification.to_sym == :maiden
        []
      elsif %w[allowance stakes].include?(qualification)
        Config::Racing.qualified_types
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

    def self.ransackable_attributes(_auth_object = nil)
      %w[allowance_placed claiming_qualified horse_id maiden_qualified nw1_allowance_qualified nw2_allowance_qualified nw3_allowance_qualified stakes_placed starter_allowance_qualified]
    end

    def to_s(mobile: false)
      base_key = "racing.race"
      base_key += ".mobile" if mobile
      base_qual = if maiden_qualified
        I18n.t("#{base_key}.maiden")
      elsif nw1_allowance_qualified
        I18n.t("#{base_key}.nw1_allowance")
      elsif nw2_allowance_qualified
        I18n.t("#{base_key}.nw2_allowance")
      elsif nw3_allowance_qualified
        I18n.t("#{base_key}.nw3_allowance")
      else
        I18n.t("#{base_key}.allowance")
      end
      base_qual += " (" + I18n.t("#{base_key}.starter_allowance") + ")" if starter_allowance_qualified
      base_qual
    end
  end
end

# == Schema Information
#
# Table name: race_qualifications
# Database name: primary
#
#  allowance_placed            :boolean          indexed
#  claiming_qualified          :boolean          indexed
#  maiden_qualified            :boolean          indexed
#  nw1_allowance_qualified     :boolean          indexed
#  nw2_allowance_qualified     :boolean          indexed
#  nw3_allowance_qualified     :boolean          indexed
#  stakes_placed               :boolean          indexed
#  starter_allowance_qualified :boolean          indexed
#  horse_id                    :bigint           primary key
#
# Indexes
#
#  index_race_qualifications_on_allowance_placed             (allowance_placed)
#  index_race_qualifications_on_claiming_qualified           (claiming_qualified)
#  index_race_qualifications_on_maiden_qualified             (maiden_qualified)
#  index_race_qualifications_on_nw1_allowance_qualified      (nw1_allowance_qualified)
#  index_race_qualifications_on_nw2_allowance_qualified      (nw2_allowance_qualified)
#  index_race_qualifications_on_nw3_allowance_qualified      (nw3_allowance_qualified)
#  index_race_qualifications_on_stakes_placed                (stakes_placed)
#  index_race_qualifications_on_starter_allowance_qualified  (starter_allowance_qualified)
#

