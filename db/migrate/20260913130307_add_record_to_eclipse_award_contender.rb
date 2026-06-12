class AddRecordToEclipseAwardContender < ActiveRecord::Migration[8.1]
  def change
    add_column :eclipse_award_contenders, :record, :string, null: false, default: "None"
  end
end

