module Horses::Stud
  class FamousStudNomination < ApplicationRecord
    self.table_name = "famous_stud_nominations"

    belongs_to :sire, class_name: "Horses::Horse", optional: true
    belongs_to :submitter, class_name: "Account::User"

    validates :name, :highlights, :height, :date_of_birth, presence: true
    validates :ran_on_dirt, :ran_on_turf, :ran_on_jumps, inclusion: { in: [true, false] }
    validates :color, inclusion: { in: Horses::Color::VALUES.keys.map(&:to_s) }
    validates :sire_name, presence: true, if: -> { sire_id.blank? }
    validate :surface_selected

    scope :current_year, -> { where("DATE_PART('Year', created_at) = ?", Date.current.year) }

    private

    def surface_selected
      return if ran_on_dirt || ran_on_turf || ran_on_jumps

      errors.add(:ran_on_dirt, :missing)
      errors.add(:ran_on_turf, :missing)
      errors.add(:ran_on_jumps, :missing)
    end
  end
end

# == Schema Information
#
# Table name: famous_stud_nominations
# Database name: primary
#
#  id                                                                                                                                                                                                                     :bigint           not null, primary key
#  color(bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan) :enum             default("bay"), not null
#  date_of_birth                                                                                                                                                                                                          :date             not null
#  face_marking(bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip)                                                                                                              :enum
#  height                                                                                                                                                                                                                 :decimal(4, 2)    default(0.0), not null
#  highlights                                                                                                                                                                                                             :text             not null
#  lf_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  lh_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  name                                                                                                                                                                                                                   :string           not null, indexed
#  ran_on_dirt                                                                                                                                                                                                            :boolean          default(FALSE), not null
#  ran_on_jumps                                                                                                                                                                                                           :boolean          default(FALSE), not null
#  ran_on_turf                                                                                                                                                                                                            :boolean          default(FALSE), not null
#  rf_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  rh_leg_marking(coronet, ermine, sock, stocking)                                                                                                                                                                        :enum
#  sire_name                                                                                                                                                                                                              :string           indexed
#  created_at                                                                                                                                                                                                             :datetime         not null
#  updated_at                                                                                                                                                                                                             :datetime         not null
#  sire_id                                                                                                                                                                                                                :bigint           indexed
#  submitter_id                                                                                                                                                                                                           :bigint           not null, indexed
#
# Indexes
#
#  index_famous_stud_nominations_on_name          (name)
#  index_famous_stud_nominations_on_sire_id       (sire_id)
#  index_famous_stud_nominations_on_sire_name     (sire_name)
#  index_famous_stud_nominations_on_submitter_id  (submitter_id)
#
# Foreign Keys
#
#  fk_rails_...  (sire_id => horses.id)
#  fk_rails_...  (submitter_id => users.id)
#

