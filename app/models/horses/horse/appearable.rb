require "image_processing/vips"

module Horses::Horse::Appearable
  extend ActiveSupport::Concern

  included do
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
          markings << pluralize(4, all_legs.first.titleize)
        else
          markings << "LF #{lf_leg_marking.titleize}" if lf_leg_marking.present?
          markings << "RF #{rf_leg_marking.titleize}" if rf_leg_marking.present?
          markings << "LH #{lh_leg_marking.titleize}" if lh_leg_marking.present?
          markings << "RH #{rh_leg_marking.titleize}" if rh_leg_marking.present?
        end
        markings.join(", ")
      end
    end

    def no_markings?
      [rf_leg_marking, lf_leg_marking, rh_leg_marking, lh_leg_marking, face_marking].all?(&:blank?)
    end
  end

  # == Schema Information
  #
  # Table name: horse_appearances
  # Database name: primary
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
  #  horse_id                                                                                                                                                                                                               :bigint           not null, uniquely indexed
  #
  # Indexes
  #
  #  index_horse_appearances_on_horse_id  (horse_id) UNIQUE
  #
  # Foreign Keys
  #
  #  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
  #
end

