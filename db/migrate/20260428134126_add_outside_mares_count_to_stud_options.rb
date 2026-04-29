class AddOutsideMaresCountToStudOptions < ActiveRecord::Migration[8.1]
  def change
    add_column :stallion_options, :outside_mares_count, :integer, default: 0, null: false, if_not_exists: true
    add_index :stallion_options, :outside_mares_count
  end
end

