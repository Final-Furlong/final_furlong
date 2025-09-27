FactoryBot.define do
  factory :legacy_racetrack, class: "Legacy::Racetrack" do
    Name { "Arlington" }
    Abbr { "Arl" }
    Location { "IL, USA" }
  end
end

# == Schema Information
#
# Table name: ff_trackdata
#
#  Abbr         :string(5)        not null
#  Banking      :integer
#  Condition    :string(4)        indexed
#  DTSC         :string(12)       indexed
#  ID           :integer          not null, primary key
#  Jumps        :integer
#  Length       :integer
#  Location     :string(255)      not null, indexed
#  Name         :string(255)      indexed
#  TurnDistance :integer
#  TurnToFinish :integer
#  Width        :integer
#
# Indexes
#
#  Condition  (Condition)
#  DTSC       (DTSC)
#  Location   (Location)
#  Name       (Name)
#

