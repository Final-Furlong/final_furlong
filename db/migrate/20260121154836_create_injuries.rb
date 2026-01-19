class CreateInjuries < ActiveRecord::Migration[8.1]
  def change
    injury_types = ["heat", "swelling", "cut", "limping", "overheat",
      "bowed tendon", "broken leg", "heart attack"]
    create_enum :injury_types, injury_types
    create_table :injuries do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.date :date, null: false, index: true
      t.enum :injury_type, enum_type: :injury_types, null: false, index: true
      t.date :rest_date, null: false, index: true

      t.timestamps
    end

    legs = %w[LF RF LH RH]
    create_enum :legs, legs
    create_table :historical_injuries do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.date :date, null: false, index: true
      t.enum :injury_type, enum_type: :injury_types, null: false, index: true
      t.enum :leg, enum_type: :legs, null: true

      t.timestamps
    end
  end
end

