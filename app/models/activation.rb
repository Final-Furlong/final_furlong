class Activation < ApplicationRecord
  belongs_to :user

  scope :activated, -> { where.not(activated_at: nil) }
end

# == Schema Information
#
# Table name: activations
#
#  id           :bigint           not null, primary key
#  activated_at :datetime
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null, indexed
#
# Indexes
#
#  index_activations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
