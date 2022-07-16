class CreateActivations < ActiveRecord::Migration[7.0]
  def change
    create_table :activations do |t|
      t.references :user, foreign_key: true
      t.string :token, null: false
      t.datetime :activated_at

      t.timestamps
    end
  end
end
