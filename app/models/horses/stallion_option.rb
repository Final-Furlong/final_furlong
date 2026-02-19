module Horses
  class StallionOption < ApplicationRecord
    belongs_to :stud, class_name: "Horses::Horse", inverse_of: :stud_option

    validates :stud_fee, :outside_mares_allowed, :outside_mares_per_stable, presence: true
    validates :approval_required, :breed_to_game_mares, inclusion: { in: [true, false] }
  end
end

# == Schema Information
#
# Table name: stallion_options
# Database name: primary
#
#  id                       :bigint           not null, primary key
#  approval_required        :boolean          default(FALSE), not null, indexed
#  breed_to_game_mares      :boolean          default(FALSE), not null, indexed
#  outside_mares_allowed    :integer          default(0), not null, indexed
#  outside_mares_per_stable :integer          default(0), not null, indexed
#  stud_fee                 :integer          default(0), not null, indexed
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stud_id                  :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_stallion_options_on_approval_required         (approval_required)
#  index_stallion_options_on_breed_to_game_mares       (breed_to_game_mares)
#  index_stallion_options_on_outside_mares_allowed     (outside_mares_allowed)
#  index_stallion_options_on_outside_mares_per_stable  (outside_mares_per_stable)
#  index_stallion_options_on_stud_fee                  (stud_fee)
#  index_stallion_options_on_stud_id                   (stud_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (stud_id => horses.id)
#

