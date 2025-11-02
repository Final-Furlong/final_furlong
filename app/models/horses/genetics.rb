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
#  id           :bigint           not null, primary key
#  allele       :string(32)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  horse_id     :integer          indexed
#  old_horse_id :uuid             not null
#  old_id       :uuid             indexed
#
# Indexes
#
#  index_horse_genetics_on_horse_id  (horse_id)
#  index_horse_genetics_on_old_id    (old_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

