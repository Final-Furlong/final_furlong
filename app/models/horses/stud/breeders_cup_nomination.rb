module Horses::Stud
  class BreedersCupNomination < ApplicationRecord
    self.table_name = "stud_breeders_cup_nominations"

    belongs_to :stud, class_name: "Horse", inverse_of: :stud_nominations

    validates :year, presence: true, uniqueness: { scope: :stud_id }
  end
end

# == Schema Information
#
# Table name: stud_breeders_cup_nominations
# Database name: primary
#
#  id         :bigint           not null, primary key
#  year       :integer          not null, uniquely indexed => [stud_id], indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stud_id    :bigint           not null, uniquely indexed => [year]
#
# Indexes
#
#  index_stud_breeders_cup_nominations_on_stud_id_and_year  (stud_id,year) UNIQUE
#  index_stud_breeders_cup_nominations_on_year              (year)
#
# Foreign Keys
#
#  fk_rails_...  (stud_id => horses.id)
#

