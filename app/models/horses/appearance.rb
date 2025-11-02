require "image_processing/vips"

module Horses
  class Appearance < ApplicationRecord
    include ActionView::Helpers::TextHelper

    self.table_name = "horse_appearances"
    self.ignored_columns += ["old_id", "old_horse_id"]

    belongs_to :horse, class_name: "Horse"

    validates :birth_height, :color, :current_height, :max_height, presence: true
    validates :current_height, comparison: { greater_than_or_equal_to: :birth_height }
    validates :max_height, comparison: { greater_than_or_equal_to: :current_height }
    validates :color, inclusion: { in: Color::VALUES.keys.map(&:to_s) }

    validates :face_marking, inclusion: { in: FaceMarking::VALUES.keys.map(&:to_s) }, allow_blank: true
    validates :face_image, absence: true, unless: :face_marking
    validates :face_image, presence: true, if: :face_marking

    validates :rf_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, allow_blank: true
    validates :rf_leg_image, presence: true, if: :rf_leg_marking
    validates :rf_leg_image, absence: true, unless: :rf_leg_marking

    validates :lf_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, allow_blank: true
    validates :lf_leg_image, presence: true, if: :lf_leg_marking
    validates :lf_leg_image, absence: true, unless: :lf_leg_marking

    validates :rh_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, allow_blank: true
    validates :rh_leg_image, presence: true, if: :rh_leg_marking
    validates :rh_leg_image, absence: true, unless: :rh_leg_marking

    validates :lh_leg_marking, inclusion: { in: LegMarking::VALUES.keys.map(&:to_s) }, allow_blank: true
    validates :lh_leg_image, presence: true, if: :lh_leg_marking
    validates :lh_leg_image, absence: true, unless: :lh_leg_marking

    delegate :gender, to: :horse

    def image(max_width: 500, max_height: 500)
      return @image if @image

      result = GenerateHorseImageService.call(horse_id: horse.id, max_height:, max_width:)
      if result.success?
        @image = result.payload
      else
        raise result.error
      end
    end

    def height_display
      I18n.t("horse.height", height: current_height)
    end

    def markings_description
      if no_markings?
        I18n.t("horse.markings.none").titleize
      else
        markings = []
        markings << I18n.t("horse.markings.#{face_marking}").titleize if face_marking.present?
        all_legs = [rh_leg_marking, lf_leg_marking, rh_leg_marking, lh_leg_marking].compact
        if all_legs.size == 4 && all_legs.uniq.size == 1
          Rails.logger.info "same markings everywhere"
          markings << pluralize(4, all_legs.first.titleize)
        else
          markings << "LF #{lf_leg_marking.titleize}" if lf_leg_marking.present?
          markings << "RF #{rf_leg_marking.titleize}" if rf_leg_marking.present?
          markings << "LH #{lh_leg_marking.titleize}" if lh_leg_marking.present?
          markings << "RH #{rh_leg_marking.titleize}" if rh_leg_marking.present?
          Rails.logger.info "not same markings everywhere"
        end
        markings.join(", ")
      end
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
#  id                                                                                                                                                                                                                     :bigint           not null, primary key
#  birth_height                                                                                                                                                                                                           :decimal(4, 2)    default(0.0), not null
#  color(bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan) :enum             default("bay"), not null
#  current_height                                                                                                                                                                                                         :decimal(4, 2)    default(0.0), not null
#  face_image                                                                                                                                                                                                             :string
#  face_marking(bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip)                                                                                                              :enum
#  lf_leg_image                                                                                                                                                                                                           :string
#  lf_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  lh_leg_image                                                                                                                                                                                                           :string
#  lh_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  max_height                                                                                                                                                                                                             :decimal(4, 2)    default(0.0), not null
#  rf_leg_image                                                                                                                                                                                                           :string
#  rf_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  rh_leg_image                                                                                                                                                                                                           :string
#  rh_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  created_at                                                                                                                                                                                                             :datetime         not null
#  updated_at                                                                                                                                                                                                             :datetime         not null
#  horse_id                                                                                                                                                                                                               :integer          not null, uniquely indexed
#
# Indexes
#
#  index_horse_appearances_on_horse_id  (horse_id) UNIQUE
#  index_horse_appearances_on_old_id    (old_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

