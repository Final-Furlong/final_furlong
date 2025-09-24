module Legacy
  class AdminSetting < Record
    self.table_name = "ff_admin"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_admin
#
#  BroodmareLimit :integer          default(25), not null
#  BugPassword    :string(50)       not null
#  EFUpdate       :date             not null
#  HorseLimit     :integer          default(150), not null
#  ID             :integer          not null, primary key
#  Members        :integer          default(75), not null
#  NoteLimit      :integer          not null
#  RacerLimit     :integer          default(25), not null
#  SatDeadline    :date
#  StartingBudget :integer          default(0), not null
#  StartingHorses :integer          default(1), not null
#  StudLimit      :integer          default(5), not null
#  WeanlingLimit  :integer          default(0), not null
#  WedDeadline    :date
#  YearlingLimit  :integer          default(0), not null
#

