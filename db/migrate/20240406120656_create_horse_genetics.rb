class CreateHorseGenetics < ActiveRecord::Migration[7.0]
  def change
    create_table :horse_genetics, id: :uuid do |t|
      t.references :horse, type: :uuid, foreign_key: { to_table: :horses }
      t.string :allele, limit: 32

      t.timestamps
    end
  end
end

