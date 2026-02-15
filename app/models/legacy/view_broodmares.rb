module Legacy
  class ViewBroodmares < Record
    self.table_name = "horse_broodmares_mv"
    self.primary_key = "horse_id"
  end
end

# == Schema Information
#
# Table name: horse_broodmares_mv
# Database name: legacy
#
#  allele               :string(32)
#  classic_level        :integer
#  classic_level_text   :string(255)
#  color                :string(30)
#  dam_dam_dosage       :string(3)
#  dam_dam_name         :string(18)
#  dam_dosage           :string(3)
#  dam_name             :string(18)
#  dam_sire_dosage      :string(3)
#  dam_sire_name        :string(18)
#  dirt_level           :integer
#  dirt_level_text      :string(255)
#  dosage               :string(3)
#  earnings             :bigint           default(0), not null
#  endurance_level      :integer
#  endurance_level_text :string(255)
#  height               :float(53)
#  horse_name           :string(18)
#  points               :integer          default(0), not null
#  race_record          :string(255)
#  sc_level             :integer
#  sc_level_text        :string(255)
#  sire_dam_dosage      :string(3)
#  sire_dam_name        :string(18)
#  sire_dosage          :string(3)
#  sire_name            :string(18)
#  sire_sire_dosage     :string(3)
#  sire_sire_name       :string(18)
#  sprint_level         :integer
#  sprint_level_text    :string(255)
#  starts               :integer          default(0), not null
#  title                :string(5)
#  turf_level           :integer
#  turf_level_text      :string(255)
#  color_id             :integer
#  dam_dam_id           :integer
#  dam_id               :integer
#  dam_sire_id          :integer
#  horse_id             :integer          unsigned, not null, primary key
#  sire_dam_id          :integer
#  sire_id              :integer
#  sire_sire_id         :integer
#

