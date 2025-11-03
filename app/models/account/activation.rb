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
#  id           :bigint           not null, primary key
#  activated_at :datetime
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_activations_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade ON UPDATE => cascade
#

