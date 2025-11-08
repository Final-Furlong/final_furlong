class AddMoreSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :settings, :dark_theme, :string
    add_column :settings, :dark_mode, :boolean, default: false, null: false
  end
end

