class DeleteActivations < ActiveRecord::Migration[8.1]
  def change
    drop_table :activations, if_exists: true do |t|
      t.datetime :activated_at
      t.string :token, null: false
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end

