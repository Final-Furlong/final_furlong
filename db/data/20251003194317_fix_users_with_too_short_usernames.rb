class FixUsersWithTooShortUsernames < ActiveRecord::Migration[8.0]
  def up
    Account::User.where("LENGTH(username) < 3").find_each do |user|
      length_to_add = 3 - user.username.length
      new_username = user.username + SecureRandom.alphanumeric(length_to_add)
      user.update(username: new_username)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

