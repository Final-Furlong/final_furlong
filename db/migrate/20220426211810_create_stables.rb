class CreateStables < ActiveRecord::Migration[7.0]
  def change
    create_table :stables do |t|
      t.string :name, null: false
      t.references :user

      t.timestamps
    end

    add_foreign_key :stables, :users
  end
end
