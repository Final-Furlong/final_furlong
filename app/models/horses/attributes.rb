module Horses
  class Attributes < ApplicationRecord
    self.table_name = "horse_attributes"

    belongs_to :horse, class_name: "Horse"

    validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
end

# == Schema Information
#
# Table name: horse_attributes
#
#  id         :uuid             not null, primary key
#  age        :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :uuid             not null, uniquely indexed
#
# Indexes
#
#  index_horse_attributes_on_horse_id  (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

