class CreateHorseAppearances < ActiveRecord::Migration[7.0]
  def change
    color_list = %w[
      bay
      black
      blood_bay
      blue_roan
      brown
      chestnut
      dapple_grey
      dark_bay
      dark_grey
      flea_bitten_grey
      grey
      light_bay
      light_chestnut
      light_grey
      liver_chestnut
      mahogany_bay
      red_chestnut
      strawberry_roan
    ]
    leg_marking_list = %w[coronet ermine sock stocking]
    face_marking_list = %w[bald_face blaze snip star star_snip star_stripe star_stripe_snip stripe stripe_snip]

    create_enum :horse_color, color_list
    create_enum :horse_leg_marking, leg_marking_list
    create_enum :horse_face_marking, face_marking_list

    create_table :horse_appearances, id: :uuid do |t|
      t.references :horse, type: :uuid, foreign_key: { to_table: :horses }

      t.enum :color, enum_type: "horse_color", default: "bay", null: false, comment: color_list.join(", ")
      t.enum :rf_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :lf_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :rh_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :lh_leg_marking, enum_type: "horse_leg_marking", default: nil, comment: leg_marking_list.join(", ")
      t.enum :face_marking, enum_type: "horse_face_marking", default: nil, comment: face_marking_list.join(", ")

      t.string :rf_leg_image, default: nil
      t.string :lf_leg_image, default: nil
      t.string :rh_leg_image, default: nil
      t.string :lh_leg_image, default: nil
      t.string :face_image, default: nil

      t.decimal :birth_height, precision: 4, scale: 2, default: 0.0
      t.decimal :current_height, precision: 4, scale: 2, default: 0.0
      t.decimal :max_height, precision: 4, scale: 2, default: 0.0

      t.timestamps
    end
  end
end

