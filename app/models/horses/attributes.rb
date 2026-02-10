module Horses
  class Attributes < ApplicationRecord
    self.table_name = "horse_attributes"

    attribute :track_record, default: -> { "Unraced" }
    attribute :breeding_record, default: -> { "none" }

    belongs_to :horse, class_name: "Horse"

    validates :track_record, :breeding_record, presence: true
    validates :title, inclusion: { in: Config::Racing.horse_titles }, allow_blank: true

    def title_string
      return unless title

      I18n.t("horse.titles.#{title.downcase.tr(" ", "_")}")
    end

    def title_abbr
      return unless title

      I18n.t("horse.titles.abbr.#{title.downcase.tr(" ", "_")}")
    end
  end
end

# == Schema Information
#
# Table name: horse_attributes
# Database name: primary
#
#  id                                                    :bigint           not null, primary key
#  breeding_record(none, bronze, silver, gold, platinum) :enum             default("none"), not null
#  dosage_text                                           :string
#  string                                                :string
#  title                                                 :string
#  track_record                                          :string           default("Unraced"), not null
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#  horse_id                                              :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_horse_attributes_on_horse_id  (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

