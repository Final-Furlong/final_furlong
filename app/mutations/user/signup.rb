# typed: true

class User::Signup < Mutations::Command
  required do
    string :username, min_length: User::USERNAME_LENGTH
    string :name
    string :email, matches: URI::MailTo::EMAIL_REGEXP
    string :password, min_length: User::PASSWORD_LENGTH
    string :password_confirmation, min_length: User::PASSWORD_LENGTH
    integer :discourse_id
    string :stable_name
  end

  def validate
    check_unique_email
    check_unique_username
    check_unique_discourse
    check_unique_stable_name
  end

  def execute
    user = User.create!(inputs)
    user.build_stable(name: stable_name)
    user.stable.save!
    user
  end

  private

  def check_unique_stable_name
    add_error(:stable_name, :unique) if Stable.exists?(name: stable_name)
  end

  def check_unique_discourse
    add_error(:discourse_id, :unique) if User.exists?(discourse_id: self.discourse_id)
  end

  def check_unique_username
    add_error(:username, :unique) if User.exists?(username: self.username)
  end

  def check_unique_email
    add_error(:email, :unique) if User.exists?(email: self.email)
  end
end
