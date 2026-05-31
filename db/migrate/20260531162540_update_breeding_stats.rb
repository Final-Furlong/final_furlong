class UpdateBreedingStats < ActiveRecord::Migration[8.1]
  def change
    add_column :breeding_stats, :allele, :string
  end
end

