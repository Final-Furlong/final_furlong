class CreateFamousStuds < ActiveRecord::Migration[8.1]
  def change
    create_table :famous_studs do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }

      t.timestamps
    end
  end
end

