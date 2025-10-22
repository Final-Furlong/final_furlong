class CreateRaceResults < ActiveRecord::Migration[8.0]
  def change
    types_list = %w[
      maiden
      claiming
      starter_allowance
      nw1_allowance
      nw2_allowance
      nw3_allowance
      allowance
      stakes
    ]
    ages_list = %w[2 2+ 3 3+ 4 4+]
    grades_list = ["Ungraded", "Grade 3", "Grade 2", "Grade 1"]
    track_conditions = %w[fast good slow wet]
    race_splits = %w[4Q 2F]
    create_enum :race_splits, race_splits

    create_table :race_results, id: :uuid do |t|
      t.date :date, null: false, index: true
      t.integer :number, default: 1, null: false, index: true
      t.enum :race_type, enum_type: "race_type", default: "maiden", null: false, index: true, comment: types_list.join(", ")
      t.enum :age, enum_type: "race_age", default: "2", null: false, index: true, comment: ages_list.join(", ")
      t.boolean :male_only, default: false, null: false, index: true
      t.boolean :female_only, default: false, null: false, index: true
      t.decimal :distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.enum :grade, enum_type: "race_grade", index: true, comment: grades_list.join(", ")
      t.references :surface, type: :uuid, null: false, index: true, foreign_key: { to_table: :track_surfaces }
      t.enum :condition, enum_type: "track_condition", index: true, comment: track_conditions.join(", ")
      t.string :name, index: true
      t.integer :purse, default: 0, null: false, index: true
      t.integer :claiming_price
      t.enum :split, enum_type: "race_splits", comment: race_splits.join(", ")
      t.decimal :time_in_seconds, precision: 7, scale: 3, default: 0.0, null: false, index: true

      t.timestamps
    end

    genders = %w[male female]
    statuses = %w[apprentice veteran retired]
    jockey_types = %w[flat jump]
    create_enum :jockey_gender, genders
    create_enum :jockey_status, statuses
    create_enum :jockey_type, jockey_types

    create_table :jockeys, id: :uuid do |t|
      t.integer :legacy_id, null: false, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date_of_birth, null: false
      t.enum :gender, enum_type: "jockey_gender", index: true, comment: genders.join(", ")
      t.enum :status, enum_type: "jockey_status", index: true, comment: statuses.join(", ")
      t.enum :jockey_type, enum_type: "jockey_type", index: true, comment: jockey_types.join(", ")
      t.integer :height_in_inches, null: false, index: true
      t.integer :weight, null: false, index: true
      t.integer :strength, null: false
      t.integer :acceleration, null: false
      t.integer :break_speed, null: false
      t.integer :min_speed, null: false
      t.integer :average_speed, null: false
      t.integer :max_speed, null: false
      t.integer :leading, null: false
      t.integer :midpack, null: false
      t.integer :off_pace, null: false
      t.integer :closing, null: false
      t.integer :consistency, null: false
      t.integer :courage, null: false
      t.integer :pissy, null: false
      t.integer :rating, null: false
      t.integer :dirt, null: false
      t.integer :turf, null: false
      t.integer :steeplechase, null: false
      t.integer :fast, null: false
      t.integer :good, null: false
      t.integer :slow, null: false
      t.integer :wet, null: false
      t.integer :turning, null: false
      t.integer :looking, null: false
      t.integer :traffic, null: false
      t.integer :loaf_threshold, null: false
      t.integer :whip_seconds, null: false
      t.integer :experience, null: false
      t.integer :experience_rate, null: false

      t.timestamps
    end

    create_table :race_odds, id: :uuid do |t|
      t.string :display, null: false
      t.decimal :value, precision: 3, scale: 1, null: false

      t.timestamps
    end

    create_table :race_result_horses, id: :uuid do |t|
      t.references :race, type: :uuid, null: false, index: true, foreign_key: { to_table: :race_results }
      t.references :horse, type: :uuid, null: false, index: true, foreign_key: { to_table: :horses }
      t.integer :legacy_horse_id, default: 0, null: false, index: true
      t.integer :post_parade, default: 1, null: false
      t.integer :finish_position, default: 1, null: false, index: true
      t.string :positions, null: false
      t.string :margins, null: false
      t.string :fractions
      t.references :jockey, type: :uuid, null: false, index: true, foreign_key: { to_table: :jockeys }
      t.integer :equipment, default: 0, null: false # flag_shih_tzu-managed bit field
      # Effective booleans which will be stored on the equipment column:
      # t.boolean      :blinkers
      # t.boolean      :shadow_wrap
      # t.boolean      :wraps
      # t.boolean      :figure_8
      # t.boolean      :no_whip
      t.references :odd, type: :uuid, null: false, index: true, foreign_key: { to_table: :race_odds }
      t.integer :speed_factor, default: 0, null: false, index: true
      t.integer :weight, default: 0, null: false

      t.timestamps
    end
  end
end

