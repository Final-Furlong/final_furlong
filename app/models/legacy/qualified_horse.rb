module Legacy
  class QualifiedHorse < Record
    self.table_name = "ff_qual_horses"
  end
end

# == Schema Information
#
# Table name: ff_qual_horses
#
#  id             :integer          not null, primary key
#  bc_places      :integer          default(0)
#  bc_points      :integer          default(0)
#  bc_shows       :integer          default(0)
#  bc_wins        :integer          default(0)
#  earnings       :integer          default(0)
#  fourths        :integer          default(0)
#  places         :integer          default(0)
#  points         :integer          default(0)
#  shows          :integer          default(0)
#  stakes_fourths :integer          default(0)
#  stakes_places  :integer          default(0)
#  stakes_shows   :integer          default(0)
#  stakes_wins    :integer          default(0)
#  wins           :integer          default(0)
#  horse_id       :integer          not null, uniquely indexed => [race_id]
#  race_id        :integer          not null, uniquely indexed => [horse_id]
#
# Indexes
#
#  horse_id  (horse_id,race_id) UNIQUE
#

