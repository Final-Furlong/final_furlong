module Legacy
  class Lease < Record
    self.table_name = "ff_leases"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_leases
#
#  Active        :boolean          default(FALSE), not null
#  End           :date             uniquely indexed => [horse, Start]
#  ID            :integer          not null, primary key
#  LeaserEnd     :boolean          default(FALSE), not null
#  LeaserEndDate :date
#  LeaserRefund  :boolean          default(FALSE), not null
#  OwnerEnd      :boolean          default(FALSE), not null
#  OwnerEndDate  :date
#  OwnerRefund   :boolean          default(FALSE), not null
#  Start         :date             not null, uniquely indexed => [horse, End]
#  Terminated    :date
#  fee           :integer
#  horse         :integer          indexed, uniquely indexed => [Start, End]
#  leaser        :integer          indexed
#  owner         :integer
#
# Indexes
#
#  Leaser       (leaser)
#  horse        (horse)
#  horse_dates  (horse,Start,End) UNIQUE
#

