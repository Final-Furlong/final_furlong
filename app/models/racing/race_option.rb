module Racing
  class RaceOption < ApplicationRecord
    include Equipmentable

    RACEHORSE_TYPES = %w[flat jump].freeze
    RACING_STYLES = %w[leading off_pace midpack closing].freeze

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :first_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :second_jockey, class_name: "Racing::Jockey", optional: true
    belongs_to :third_jockey, class_name: "Racing::Jockey", optional: true

    validates :minimum_distance, :maximum_distance,
      :calculated_maximum_distance, :calculated_minimum_distance, :equipment,
      presence: true
    validates :racehorse_type, inclusion: { in: RACEHORSE_TYPES }
    validates :racing_style, inclusion: { in: RACING_STYLES }
    validates :minimum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
    validates :maximum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
    validates :calculated_minimum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
    validates :calculated_maximum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
    validates :runs_on_dirt, :runs_on_turf, :trains_on_dirt, :trains_on_turf,
      :trains_on_jumps, inclusion: { in: [true, false] }
    validates :next_race_note_created_at, presence: true, if: :note_for_next_race
  end
end

# == Schema Information
#
# Table name: race_options
# Database name: primary
#
#  id                                             :bigint           not null, primary key
#  calculated_maximum_distance                    :decimal(3, 1)    default(5.0), not null, indexed
#  calculated_minimum_distance                    :decimal(3, 1)    default(24.0), not null, indexed
#  equipment                                      :integer          default(0), not null
#  maximum_distance                               :decimal(3, 1)    default(24.0), not null, indexed
#  minimum_distance                               :decimal(3, 1)    default(5.0), not null, indexed
#  next_race_note_created_at                      :datetime         indexed
#  note_for_next_race                             :text
#  racehorse_type(flat,jump)                      :enum             indexed
#  racing_style(leading,off_pace,midpack,closing) :enum             indexed
#  runs_on_dirt                                   :boolean          default(TRUE), not null
#  runs_on_turf                                   :boolean          default(TRUE), not null
#  trains_on_dirt                                 :boolean          default(TRUE), not null
#  trains_on_jumps                                :boolean          default(FALSE), not null
#  trains_on_turf                                 :boolean          default(TRUE), not null
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  first_jockey_id                                :bigint           indexed
#  horse_id                                       :bigint           not null, uniquely indexed
#  second_jockey_id                               :bigint           indexed
#  third_jockey_id                                :bigint           indexed
#
# Indexes
#
#  index_race_options_on_calculated_maximum_distance  (calculated_maximum_distance)
#  index_race_options_on_calculated_minimum_distance  (calculated_minimum_distance)
#  index_race_options_on_first_jockey_id              (first_jockey_id)
#  index_race_options_on_horse_id                     (horse_id) UNIQUE
#  index_race_options_on_maximum_distance             (maximum_distance)
#  index_race_options_on_minimum_distance             (minimum_distance)
#  index_race_options_on_next_race_note_created_at    (next_race_note_created_at)
#  index_race_options_on_racehorse_type               (racehorse_type)
#  index_race_options_on_racing_style                 (racing_style)
#  index_race_options_on_second_jockey_id             (second_jockey_id)
#  index_race_options_on_third_jockey_id              (third_jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_jockey_id => jockeys.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (second_jockey_id => jockeys.id)
#  fk_rails_...  (third_jockey_id => jockeys.id)
#

