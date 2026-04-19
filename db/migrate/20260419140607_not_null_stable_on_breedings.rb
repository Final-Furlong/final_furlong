class NotNullStableOnBreedings < ActiveRecord::Migration[8.1]
  def change
    change_column_null :breedings, :stable_id, false
  end
end

