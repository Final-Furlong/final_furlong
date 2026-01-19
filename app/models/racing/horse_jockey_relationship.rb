module Racing
  class HorseJockeyRelationship < ApplicationRecord
    self.table_name = "horse_jockey_relationships"

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :jockey, class_name: "Racing::Jockey"

    validates :experience, :happiness, presence: true
    validates :experience, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
    validates :happiness, numericality: { only_integer: true, less_than_or_equal_to: 100 }
  end
end

# == Schema Information
#
# Table name: horse_jockey_relationships
# Database name: primary
#
#  id         :bigint           not null, primary key
#  experience :integer          default(0), not null
#  happiness  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, uniquely indexed => [jockey_id]
#  jockey_id  :bigint           not null, uniquely indexed => [horse_id], indexed
#
# Indexes
#
#  index_horse_jockey_relationships_on_horse_id_and_jockey_id  (horse_id,jockey_id) UNIQUE
#  index_horse_jockey_relationships_on_jockey_id               (jockey_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (jockey_id => jockeys.id)
#

