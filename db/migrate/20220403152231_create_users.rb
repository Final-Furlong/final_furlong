class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_enum :user_status, %w[pending active deleted banned]

    create_table :users do |t|
      t.string :username, null: false
      t.enum :status, enum_type: "user_status", default: "pending", null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :admin, null: false, default: false
      t.integer :discourse_id

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :discourse_id, unique: true
  end
end
