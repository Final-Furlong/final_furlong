class AddSoundnessQualityToHorseGenetics < ActiveRecord::Migration[8.1]
  def change
    add_column :horse_genetics, :soundness, :integer, null: false, default: 0
    add_column :horse_genetics, :quality, :integer, null: false, default: 0

    add_index :horse_genetics, :soundness
    add_index :horse_genetics, :quality
  end
end

