module Horses
  class Genetics < ApplicationRecord
    self.table_name = "horse_genetics"

    belongs_to :horse, class_name: "Horses::Horse"

    validates :soundness, :quality, presence: true
    validates :allele, length: { maximum: 32 }, presence: true
  end
end

# == Schema Information
#
# Table name: horse_genetics
# Database name: primary
#
#  id         :bigint           not null, primary key
#  allele     :string(32)       not null
#  quality    :integer          default(0), not null, indexed
#  soundness  :integer          default(0), not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_horse_genetics_on_horse_id   (horse_id) UNIQUE
#  index_horse_genetics_on_quality    (quality)
#  index_horse_genetics_on_soundness  (soundness)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

