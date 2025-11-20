RSpec.describe Racing::RaceOption do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:first_jockey).class_name("Racing::Jockey").optional }
    it { is_expected.to belong_to(:second_jockey).class_name("Racing::Jockey").optional }
    it { is_expected.to belong_to(:third_jockey).class_name("Racing::Jockey").optional }
  end

  # validates :minimum_distance, :maximum_distance,
  #   :calculated_maximum_distance, :calculated_minimum_distance, :equipment,
  #   presence: true
  # validates :racehorse_type, inclusion: { in: RACEHORSE_TYPES }
  # validates :racing_style, inclusion: { in: RACING_STYLES }
  # validates :minimum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  # validates :maximum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  # validates :calculated_minimum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  # validates :calculated_maximum_distance, numericality: { greater_than_or_equal_to: 5.0, less_than_or_equal_to: 24.0 }
  # validates :runs_on_dirt, :runs_on_turf, :trains_on_dirt, :trains_on_turf,
  #   :trains_on_jumps, inclusion: { in: [true, false] }
  # validates :next_race_note_created_at, presence: true, if: :note_for_next_race
end

