class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_enum :user_status, %w[pending active deleted banned]

    create_table :users do |t|
      t.string :username, null: false
      t.enum :status, enum_type: "user_status", default: "pending", null: false,
                      comment: "pending, active, deleted, banned"
      t.string :name, null: false, comment: "displayed on profile"
      t.string :email, null: false
      t.boolean :admin, null: false, default: false
      t.integer :discourse_id, comment: "integer from Discourse forum"

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :discourse_id, unique: true
  end
end

