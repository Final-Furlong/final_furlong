module Legacy
  class Jockey < Record
    self.table_name = "ff_jockeys"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_jockeys
#
#  Acceleration :integer          default(0), not null
#  Ave          :integer          default(0), not null
#  Break        :integer          default(0), not null
#  Close        :integer          default(0), not null
#  Consistency  :integer          default(0), not null
#  Courage      :integer          default(0), not null
#  DOB          :date             default(NULL), not null
#  Dirt         :integer          default(0), not null
#  Fast         :integer          default(0), not null
#  First        :string(255)      not null, indexed
#  Gender       :string           default("M"), not null, indexed
#  Good         :integer          default(0), not null
#  Height       :integer          default(0), not null
#  ID           :integer          not null, primary key
#  Last         :string(255)      not null, indexed
#  Lead         :integer          default(0), not null
#  LoafThresh   :integer          default(0), not null
#  Looking      :integer          default(0), not null
#  Max          :integer          default(0), not null
#  Midpack      :integer          default(0), not null
#  Min          :integer          default(0), not null
#  Pace         :integer          default(0), not null
#  Pissy        :integer          default(0), not null
#  Rating       :integer          default(0), not null
#  SC           :integer          default(0), not null
#  Slow         :integer          default(0), not null
#  Status       :integer          default(1), not null, indexed
#  Strength     :integer          default(0), not null
#  Traffic      :integer          default(0), not null
#  Turf         :integer          default(0), not null
#  Turning      :integer          default(0), not null
#  Weight       :integer          default(0), not null
#  Wet          :integer          default(0), not null
#  WhipSec      :integer          default(0), not null
#  XPCurrent    :integer          default(0), not null
#  XPRate       :float(53)        default(0.0), not null
#  slug         :string(255)
#
# Indexes
#
#  First   (First)
#  Gender  (Gender)
#  Last    (Last)
#  Status  (Status)
#

