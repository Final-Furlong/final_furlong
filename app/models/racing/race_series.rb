module Racing
  class RaceSeries < ApplicationRecord
    belongs_to :first_race, class_name: "RaceSchedule"
    belongs_to :second_race, class_name: "RaceSchedule"
    belongs_to :third_race, class_name: "RaceSchedule"

    has_many :winners, class_name: "RaceSeriesWinner", inverse_of: :series, dependent: :delete_all

    validates :title, presence: true
    validates :age, inclusion: { in: Config::Racing.ages }
    validates :female_only, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: race_series
# Database name: primary
#
#  id             :bigint           not null, primary key
#  age            :enum             not null, indexed
#  female_only    :boolean          default(FALSE), not null, indexed
#  title          :string           not null, indexed
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_race_id  :bigint           not null, indexed => [second_race_id, third_race_id]
#  second_race_id :bigint           not null, indexed => [first_race_id, third_race_id], indexed
#  third_race_id  :bigint           not null, indexed => [first_race_id, second_race_id], indexed
#
# Indexes
#
#  idx_on_first_race_id_second_race_id_third_race_id_8fa7a43bf7  (first_race_id,second_race_id,third_race_id)
#  index_race_series_on_age                                      (age)
#  index_race_series_on_female_only                              (female_only)
#  index_race_series_on_second_race_id                           (second_race_id)
#  index_race_series_on_third_race_id                            (third_race_id)
#  index_race_series_on_title                                    (title)
#
# Foreign Keys
#
#  fk_rails_...  (first_race_id => race_schedules.id)
#  fk_rails_...  (second_race_id => race_schedules.id)
#  fk_rails_...  (third_race_id => race_schedules.id)
#

