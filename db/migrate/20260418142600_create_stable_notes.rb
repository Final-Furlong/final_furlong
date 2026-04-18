class CreateStableNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :stable_notes do |t|
      t.references :stable, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.string :title, null: false, index: true
      t.text :text, index: true
      t.boolean :private, default: true, null: false, index: true

      t.timestamps
    end
  end
end

