module Horses
  class Genetics < ApplicationRecord
    self.table_name = "horse_genetics"

    belongs_to :horse, class_name: "Horse"

    validates :allele, length: { maximum: 32 }, presence: true
  end
end

# == Schema Information
#
# Table name: horse_genetics
#
#  id         :uuid             not null, primary key
#  allele     :string(32)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :uuid             indexed
#
# Indexes
#
#  index_horse_genetics_on_horse_id  (horse_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

