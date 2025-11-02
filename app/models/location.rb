class Location < ApplicationRecord
  has_many :racetracks, class_name: "Racing::Racetrack", dependent: :restrict_with_exception

  validates :name, :country, presence: true
  validates :name, uniqueness: { scope: :country }
end

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  country    :string           not null, uniquely indexed => [name]
#  county     :string
#  name       :string           not null, uniquely indexed => [country], indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_country_and_name  (country,name) UNIQUE
#  index_locations_on_name              (name)
#  index_locations_on_old_id            (old_id)
#

