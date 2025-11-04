module Legacy
  class UserPreference < Record
    self.primary_key = "user_id"
  end
end

# == Schema Information
#
# Table name: user_preferences
# Database name: legacy
#
#  training_energy_minimum :string(1)
#  user_id                 :integer          unsigned, not null, primary key
#

