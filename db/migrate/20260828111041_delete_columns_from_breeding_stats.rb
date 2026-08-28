class DeleteColumnsFromBreedingStats < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :breeding_stats, :allele, :string
      remove_column :breeding_stats, :soundness, :integer
    end
  end
end

