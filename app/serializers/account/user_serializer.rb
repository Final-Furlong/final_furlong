module Account
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                       :bigint           not null, primary key
#  admin                                    :boolean          default(FALSE), not null, indexed
#  confirmation_sent_at                     :datetime
#  confirmation_token                       :string
#  confirmed_at                             :datetime
#  current_sign_in_at                       :datetime
#  current_sign_in_ip                       :string
#  developer                                :boolean          default(FALSE), not null, indexed
#  discarded_at                             :datetime
#  email                                    :string           default(""), not null, uniquely indexed
#  encrypted_password                       :string           default(""), not null
#  failed_attempts                          :integer          default(0), not null
#  last_sign_in_at                          :datetime
#  last_sign_in_ip                          :string
#  locked_at                                :datetime
#  name                                     :string           not null, indexed
#  remember_created_at                      :datetime
#  reset_password_sent_at                   :datetime
#  reset_password_token                     :string
#  sign_in_count                            :integer          default(0), not null
#  slug                                     :string           uniquely indexed
#  status(pending, active, deleted, banned) :enum             default("pending"), not null
#  unconfirmed_email                        :string
#  unlock_token                             :string
#  username                                 :string           not null, uniquely indexed
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  discourse_id                             :integer          uniquely indexed
#  public_id                                :string(12)       uniquely indexed
#
# Indexes
#
#  index_users_on_admin         (admin) WHERE (discarded_at IS NOT NULL)
#  index_users_on_developer     (developer) WHERE (discarded_at IS NOT NULL)
#  index_users_on_discourse_id  (discourse_id) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_email         (email) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_name          (name) WHERE (discarded_at IS NOT NULL)
#  index_users_on_old_id        (old_id)
#  index_users_on_public_id     (public_id) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_slug          (slug) UNIQUE WHERE (discarded_at IS NOT NULL)
#  index_users_on_username      (username) UNIQUE WHERE (discarded_at IS NOT NULL)
#

