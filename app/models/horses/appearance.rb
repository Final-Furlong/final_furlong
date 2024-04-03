require "image_processing/vips"

module Horses
  class Appearance < ApplicationRecord
    self.table_name = "horse_appearances"

    belongs_to :horse, class_name: "Horse"

    has_one_attached :image

    validates :birth_height, :color, :current_height, :max_height, presence: true
    validates :image, presence: true, on: :image_creation
    validates :current_height, comparison: { greater_than_or_equal_to: :birth_height }
    validates :max_height, comparison: { greater_than_or_equal_to: :current_height }
    validates :color, inclusion: { in: Color::VALUES.keys.map(&:to_s) }

    validates :face_marking, inclusion: { in: FaceMarking::VALUES.keys.map(&:to_s) }
    validates :face_image, absence: true, unless: :face_marking
    validates :face_image, presence: true, if: :face_marking

    validates :rf_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, if: :rf_leg_marking
    validates :rf_leg_image, presence: true, if: :rf_leg_marking
    validates :rf_leg_image, absence: true, unless: :rf_leg_marking

    validates :lf_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, if: :lf_leg_marking
    validates :lf_leg_image, presence: true, if: :lf_leg_marking
    validates :lf_leg_image, absence: true, unless: :lf_leg_marking

    validates :rh_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, if: :rh_leg_marking
    validates :rh_leg_image, presence: true, if: :rh_leg_marking
    validates :rh_leg_image, absence: true, unless: :rh_leg_marking

    validates :lh_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, if: :lh_leg_marking
    validates :lh_leg_image, presence: true, if: :lh_leg_marking
    validates :lh_leg_image, absence: true, unless: :lh_leg_marking

    after_commit :create_image

    delegate :gender, to: :horse

    def create_image
      GenerateHorseImageJob.perform_async(horse.id) if image.blank?
    end

    def no_markings?
      [rf_leg_marking, lf_leg_marking, rh_leg_marking, lh_leg_marking, face_marking].all?(&:blank?)
    end
  end
end

# == Schema Information
#
# Table name: horse_appearances
#
#  id             :uuid             not null, primary key
#  birth_height   :decimal(4, 2)    default(0.0)
#  color          :enum             default("bay"), not null
#  current_height :decimal(4, 2)    default(0.0)
#  face_image     :string
#  face_marking   :enum
#  lf_leg_image   :string
#  lf_leg_marking :enum
#  lh_leg_image   :string
#  lh_leg_marking :enum
#  max_height     :decimal(4, 2)    default(0.0)
#  rf_leg_image   :string
#  rf_leg_marking :enum
#  rh_leg_image   :string
#  rh_leg_marking :enum
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  horse_id       :uuid             indexed
#
# Indexes
#
#  index_horse_appearances_on_horse_id  (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

