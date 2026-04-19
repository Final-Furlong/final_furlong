class AllowNullLegacyIdOnBreedings < ActiveRecord::Migration[8.1]
  def change
    change_column_null :breedings, :legacy_id, true
    remove_index :breedings, :legacy_id, if_exists: true
  end
end

