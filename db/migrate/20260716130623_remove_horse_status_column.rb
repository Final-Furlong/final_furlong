class RemoveHorseStatusColumn < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :horses, :status, :enum, enum_type: :horse_statuses, if_exists: true
    end
  end
end

