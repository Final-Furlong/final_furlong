class CreateUserActivations < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Deleting existing records" do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE activations;")
    end
    say_with_time "Creating user activations" do
      say "User count: #{User.pending.count}"
      User.pending.find_each do |user|
        CreateActivationService.new(user.id).call
      end
    end
  end

  def down
    say_with_time "Deleting existing records" do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE activations;")
    end
  end
end
