class CreateUserPushSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_push_subscriptions, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: { to_table: :users }, null: false
      t.string :auth_key
      t.string :endpoint
      t.string :p256dh_key
      t.string :user_agent

      t.timestamps
    end
  end
end

