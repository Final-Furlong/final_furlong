class AddCheckConstraints < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint(:horse_appearances, "current_height >= birth_height", name: "current_height_must_be_valid")
    add_check_constraint(:horse_appearances, "max_height >= current_height", name: "max_height_must_be_valid")
  end
end

