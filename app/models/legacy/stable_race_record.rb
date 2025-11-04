module Legacy
  class StableRaceRecord < Record
    self.table_name = "ff_stablerrs"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_stablerrs
# Database name: legacy
#
#  Fourth       :integer          default(0), not null
#  ID           :integer          not null, primary key
#  Money        :integer          default(0), not null
#  Place        :integer          default(0), not null
#  Races        :integer          default(0), not null
#  Shows        :integer          default(0), not null
#  Stable       :integer          default(0), not null, indexed, uniquely indexed => [Year]
#  Win          :integer          default(0), not null
#  Year         :integer          indexed, uniquely indexed => [Stable]
#  stakes       :integer          default(0), not null
#  stakesfourth :integer          default(0), not null
#  stakesplace  :integer          default(0), not null
#  stakesshow   :integer          default(0), not null
#  stakeswin    :integer          default(0), not null
#
# Indexes
#
#  Stable       (Stable)
#  Year         (Year)
#  stable_year  (Stable,Year) UNIQUE
#

