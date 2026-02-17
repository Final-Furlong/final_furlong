class CreateStallionOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :stallion_options do |t|
      t.references :stud, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.integer :stud_fee, null: false, default: 0, index: true
      t.integer :outside_mares_allowed, null: false, default: 0, index: true
      t.integer :outside_mares_per_stable, null: false, default: 0, index: true
      t.boolean :approval_required, null: false, default: false, index: true
      t.boolean :breed_to_game_mares, null: false, default: false, index: true

      t.timestamps
    end

    add_index :stallion_options, :stud_id, unique: true
  end
end

