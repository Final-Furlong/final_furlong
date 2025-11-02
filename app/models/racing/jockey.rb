module Racing
  class Jockey < ApplicationRecord
    include PublicIdGenerator

    self.table_name = "jockeys"
    self.ignored_columns += ["old_id"]

    GENDERS = %w[male female].freeze
    TYPES = %w[flat jump].freeze
    STATUSES = %w[apprentice veteran retired].freeze

    has_many :race_result_horses, class_name: "Racing::RaceResultHorse", inverse_of: :jockey, dependent: :nullify

    validates :legacy_id, :first_name, :last_name, :date_of_birth, :height_in_inches,
              :weight, :strength, :acceleration, :break_speed, :min_speed, :average_speed,
              :max_speed, :leading, :midpack, :off_pace, :closing, :consistency, :courage,
              :pissy, :rating, :dirt, :turf, :steeplechase, :fast, :good, :slow, :wet,
              :turning, :looking, :traffic, :loaf_threshold, :whip_seconds, :experience,
              :experience_rate, presence: true
    validates :acceleration, :leading, :off_pace, :closing, :midpack, :consistency, :courage, :dirt, :turf, :steeplechase,
              :fast, :good, :wet, :slow, :loaf_threshold, :pissy, :rating, :strength, :traffic, :whip_seconds,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
    validates :experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :experience_rate, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 0.5 }
    validates :break_speed, :min_speed, :average_speed, :max_speed, :turning,
              numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
    validates :first_name, :last_name, length: { minimum: 3 }
    validates :gender, inclusion: { in: GENDERS }
    validates :height_in_inches, numericality: { only_integer: true, greater_than_or_equal_to: 48, less_than_or_equal_to: 70 }
    validates :jockey_type, inclusion: { in: TYPES }
    validates :looking, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 100 }
    validates :status, inclusion: { in: STATUSES }
    validates :weight, numericality: { only_integer: true, greater_than_or_equal_to: 35, less_than_or_equal_to: 120 }
  end
end

# == Schema Information
#
# Table name: jockeys
#
#  id                                   :bigint           not null, primary key
#  acceleration                         :integer          not null
#  average_speed                        :integer          not null
#  break_speed                          :integer          not null
#  closing                              :integer          not null
#  consistency                          :integer          not null
#  courage                              :integer          not null
#  date_of_birth                        :date             not null, indexed
#  dirt                                 :integer          not null
#  experience                           :integer          not null
#  experience_rate                      :integer          not null
#  fast                                 :integer          not null
#  first_name                           :string           not null, indexed
#  gender(male, female)                 :enum             indexed
#  good                                 :integer          not null
#  height_in_inches                     :integer          not null, indexed
#  jockey_type(flat, jump)              :enum             indexed
#  last_name                            :string           not null, indexed
#  leading                              :integer          not null
#  loaf_threshold                       :integer          not null
#  looking                              :integer          not null
#  max_speed                            :integer          not null
#  midpack                              :integer          not null
#  min_speed                            :integer          not null
#  off_pace                             :integer          not null
#  pissy                                :integer          not null
#  rating                               :integer          not null
#  slow                                 :integer          not null
#  slug                                 :string           indexed
#  status(apprentice, veteran, retired) :enum             indexed
#  steeplechase                         :integer          not null
#  strength                             :integer          not null
#  traffic                              :integer          not null
#  turf                                 :integer          not null
#  turning                              :integer          not null
#  weight                               :integer          not null, indexed
#  wet                                  :integer          not null
#  whip_seconds                         :integer          not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  legacy_id                            :integer          not null, indexed
#  old_id                               :uuid             indexed
#  public_id                            :string(12)       indexed
#
# Indexes
#
#  index_jockeys_on_date_of_birth     (date_of_birth)
#  index_jockeys_on_first_name        (first_name)
#  index_jockeys_on_gender            (gender)
#  index_jockeys_on_height_in_inches  (height_in_inches)
#  index_jockeys_on_jockey_type       (jockey_type)
#  index_jockeys_on_last_name         (last_name)
#  index_jockeys_on_legacy_id         (legacy_id)
#  index_jockeys_on_old_id            (old_id)
#  index_jockeys_on_public_id         (public_id)
#  index_jockeys_on_slug              (slug)
#  index_jockeys_on_status            (status)
#  index_jockeys_on_weight            (weight)
#

