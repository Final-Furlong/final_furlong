class CreateFamousStudNomination < ActiveRecord::Migration[8.1]
  def change
    create_table :famous_stud_nominations do |t|
      t.references :submitter, type: :bigint, null: false, index: false, foreign_key: { to_table: :users }
      t.string :name, null: false, index: true
      t.references :sire, type: :bigint, index: false, foreign_key: { to_table: :horses }
      t.string :sire_name, index: true
      t.date :date_of_birth, null: false
      t.boolean :ran_on_dirt, null: false, default: false
      t.boolean :ran_on_turf, null: false, default: false
      t.boolean :ran_on_jumps, null: false, default: false
      t.text :highlights, null: false
      t.enum :color, default: "bay", null: false, comment: "bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan", enum_type: "horse_color"
      t.decimal :height, precision: 4, scale: 2, default: "0.0", null: false
      t.enum :face_marking, comment: "bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip", enum_type: "horse_face_marking"
      t.enum :lf_leg_marking, comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum :lh_leg_marking, comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum :rf_leg_marking, comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"
      t.enum :rh_leg_marking, comment: "coronet, ermine, sock, stocking", enum_type: "horse_leg_marking"

      t.timestamps
    end

    add_index :famous_stud_nominations, :submitter_id
    add_index :famous_stud_nominations, :sire_id
  end
end

