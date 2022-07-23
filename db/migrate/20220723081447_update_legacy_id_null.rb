class UpdateLegacyIdNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :stables, :legacy_id, true
  end
end
