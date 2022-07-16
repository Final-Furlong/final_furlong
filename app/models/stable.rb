class Stable < ApplicationRecord
  belongs_to :user

  has_many :bred_horses, class_name: "Horse", foreign_key: :breeder_id, inverse_of: :breeder,
                         dependent: :restrict_with_exception
  has_many :horses, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception
end

# == Schema Information
#
# Table name: stables
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           indexed
#
# Indexes
#
#  index_stables_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
