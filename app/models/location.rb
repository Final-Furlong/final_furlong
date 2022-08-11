class Location < ApplicationRecord
  has_many :racetracks
end

# == Schema Information
#
# Table name: locations
#
#  id         :uuid             not null, primary key
#  country    :string           not null
#  county     :string
#  name       :string           not null
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
