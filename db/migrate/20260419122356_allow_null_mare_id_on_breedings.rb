class AllowNullMareIdOnBreedings < ActiveRecord::Migration[8.1]
  def change
    change_column_null :breedings, :mare_id, true
  end
end

