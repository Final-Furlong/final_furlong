class AddLegacyIdToHorse < ActiveRecord::Migration[7.0]
  def change
    add_column :horses, :legacy_id, :integer
    add_index :horses, :legacy_id, unique: true
  end
end

