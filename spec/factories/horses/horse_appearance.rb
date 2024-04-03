FactoryBot.define do
  factory :horse_appearance, class: "Horses::Appearance" do
    horse
    birth_height { rand(10.0..20.0).round(2) }
    current_height { birth_height + 1.0 }
    max_height { current_height + 1.0 }
    color { "light_grey" }
    face_marking { Horses::FaceMarking::VALUES.keys.sample }
    rf_leg_marking { Horses::LegMarking::VALUES.keys.sample.to_s }
    lf_leg_marking { Horses::LegMarking::VALUES.keys.sample.to_s }
    lh_leg_marking { Horses::LegMarking::VALUES.keys.sample.to_s }
    rh_leg_marking { Horses::LegMarking::VALUES.keys.sample.to_s }
    face_image do
      "snip.png"
    end
    rf_leg_image do
      case rf_leg_marking.to_s
      when "coronet"
        "coronet.png"
      else
        marking1 = "#{rf_leg_marking}1.png"
        marking2 = "#{rf_leg_marking}2.png"
        [marking1, marking2].sample
      end
    end
    lf_leg_image do
      case lf_leg_marking.to_s
      when "coronet"
        "coronet.png"
      else
        marking1 = "#{lf_leg_marking}1.png"
        marking2 = "#{lf_leg_marking}2.png"
        [marking1, marking2].sample
      end
    end
    rh_leg_image do
      case rh_leg_marking.to_s
      when "coronet"
        "coronet.png"
      else
        marking1 = "#{rh_leg_marking}1.png"
        marking2 = "#{rh_leg_marking}2.png"
        [marking1, marking2].sample
      end
    end
    lh_leg_image do
      case lh_leg_marking.to_s
      when "coronet"
        "coronet.png"
      else
        marking1 = "#{lh_leg_marking}1.png"
        marking2 = "#{lh_leg_marking}2.png"
        [marking1, marking2].sample
      end
    end

    trait :plain do
      face_marking { nil }
      rf_leg_marking { nil }
      lf_leg_marking { nil }
      lh_leg_marking { nil }
      rh_leg_marking { nil }
      face_image { nil }
      rf_leg_image { nil }
      lf_leg_image { nil }
      rh_leg_image { nil }
      lh_leg_image { nil }
    end
  end
end

# == Schema Information
#
# Table name: horses
#
#  id                 :uuid             not null, primary key
#  age                :integer
#  date_of_birth      :date             not null, indexed
#  date_of_death      :date
#  foals_count        :integer          default(0), not null
#  gender             :enum             not null
#  name               :string(18)       indexed
#  status             :enum             default("unborn"), not null, indexed
#  unborn_foals_count :integer          default(0), not null
#  created_at         :datetime         not null, indexed
#  updated_at         :datetime         not null
#  breeder_id         :uuid             not null, indexed
#  dam_id             :uuid             indexed
#  legacy_id          :integer          indexed
#  location_bred_id   :uuid             not null, indexed
#  owner_id           :uuid             not null, indexed
#  sire_id            :uuid             indexed
#
# Indexes
#
#  index_horses_on_breeder_id        (breeder_id)
#  index_horses_on_created_at        (created_at)
#  index_horses_on_dam_id            (dam_id)
#  index_horses_on_date_of_birth     (date_of_birth)
#  index_horses_on_legacy_id         (legacy_id) UNIQUE
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_name              (name)
#  index_horses_on_owner_id          (owner_id)
#  index_horses_on_sire_id           (sire_id)
#  index_horses_on_status            (status)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id)
#  fk_rails_...  (dam_id => horses.id)
#  fk_rails_...  (location_bred_id => locations.id)
#  fk_rails_...  (owner_id => stables.id)
#  fk_rails_...  (sire_id => horses.id)
#

