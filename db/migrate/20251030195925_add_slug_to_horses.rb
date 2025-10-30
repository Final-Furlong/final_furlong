class AddSlugToHorses < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :horses, :slug, :string
    add_index :horses, :slug, unique: true, algorithm: :concurrently
  end
end

