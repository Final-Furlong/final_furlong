class AddAutoFlagToBreedings < ActiveRecord::Migration[8.1]
  def change
    add_column :breedings, :auto, :boolean, null: false, default: false

    add_index :breedings, :auto
  end
end

