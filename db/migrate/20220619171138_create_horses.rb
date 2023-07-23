class CreateHorses < ActiveRecord::Migration[7.0]
  def change
    status_list = %w[
      unborn
      weanling
      yearling
      racehorse
      broodmare
      stud
      retired
      retired_broodmare
      retired_stud
      deceased
    ]
    gender_list = %w[colt filly mare stallion gelding]

    create_enum :horse_status, status_list
    create_enum :horse_gender, gender_list

    create_table :horses do |t|
      t.string :name
      t.string :gender, enum_type: "horse_gender", null: false,
        comment: gender_list.join(", ")
      t.enum :status, enum_type: "horse_status", default: "unborn", null: false,
        index: true, comment: status_list.join(", ")
      t.date :date_of_birth, null: false, index: true
      t.date :date_of_death
      t.references :owner, foreign_key: { to_table: :stables }
      t.references :breeder, foreign_key: { to_table: :stables }
      t.references :location_bred, foreign_key: { to_table: :racetracks }
      t.references :sire, foreign_key: { to_table: :horses }
      t.references :dam, foreign_key: { to_table: :horses }

      t.timestamps
    end
  end
end

