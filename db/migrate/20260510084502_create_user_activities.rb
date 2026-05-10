class CreateUserActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :user_activities do |t|
      t.references :user, type: :bigint, null: false, index: false, foreign_key: { to_table: :users }
      t.jsonb :activities, default: {}

      t.timestamps
    end

    add_index :user_activities, :user_id, unique: true
    add_index :user_activities, :activities, using: :gin
  end
end

