module Account
  class Activation < ApplicationRecord
    belongs_to :user

    validates :token, presence: true
  end
end

# == Schema Information
#
# Table name: activations
#
#  id           :integer          not null, primary key
#  token        :string           not null
#  activated_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null, indexed
#
# Indexes
#
#  index_activations_on_user_id  (user_id) UNIQUE
#

