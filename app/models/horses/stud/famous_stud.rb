module Horses
  module Stud
    class FamousStud < ApplicationRecord
      belongs_to :horse, class_name: "Horses::Horse", inverse_of: :famous_stud

      validates :horse_id, uniqueness: true
    end
  end
end

# == Schema Information
#
# Table name: famous_studs
# Database name: primary
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_famous_studs_on_horse_id  (horse_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

