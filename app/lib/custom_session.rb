class CustomSession < ActiveRecord::SessionStore::Session
  before_save :set_user_id

  private

  def set_user_id
    self.user_id = data["warden.user.user.key"].first.first if data["warden.user.user.key"].present?
  end
end
