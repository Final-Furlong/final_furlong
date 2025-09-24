module Legacy
  class HorseJockey < Record
    self.table_name = "ff_horse_jockeys"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_jockeys
#
#  Happy  :integer          default(0), not null
#  Horse  :integer          default(0), not null, indexed => [Jockey]
#  ID     :integer          not null, primary key
#  Jockey :integer          default(0), not null, indexed => [Horse]
#  XP     :integer          default(0), not null
#
# Indexes
#
#  Horse  (Horse,Jockey)
#

