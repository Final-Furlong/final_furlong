module Horses
  class Attributes < ApplicationRecord
    self.table_name = "horse_attributes"
    self.ignored_columns += ["old_id", "old_horse_id"]

    TITLES = ["Final Furlong", "World", "International", "National", "Grand", "Normal"].freeze

    attribute :track_record, default: -> { "Unraced" }
    attribute :breeding_record, default: -> { "None" }

    belongs_to :horse, class_name: "Horse"

    validates :track_record, :breeding_record, presence: true
    validates :title, inclusion: { in: TITLES }, allow_blank: true

    def title_string
      I18n.t("horse.titles.#{title.downcase.tr(" ", "_")}")
    end

    def title_abbr
      I18n.t("horse.titles.abbr.#{title.downcase.tr(" ", "_")}")
    end
  end
end

# == Schema Information
#
# Table name: horse_attributes
#
#  id                                                    :bigint           not null, primary key
#  breeding_record(none, bronze, silver, gold, platinum) :enum             default("None"), not null
#  dosage_text                                           :string
#  string                                                :string
#  title                                                 :string
#  track_record                                          :string           default("Unraced"), not null
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#  horse_id                                              :bigint           not null, uniquely indexed
#  old_horse_id                                          :uuid             not null, indexed
#  old_id                                                :uuid             indexed
#
# Indexes
#
#  index_horse_attributes_on_horse_id      (horse_id) UNIQUE
#  index_horse_attributes_on_old_horse_id  (old_horse_id)
#  index_horse_attributes_on_old_id        (old_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

