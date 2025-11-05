class Location < ApplicationRecord
  has_one :racetrack, class_name: "Racing::Racetrack", dependent: :restrict_with_exception

  validates :name, :country, presence: true
  validates :name, uniqueness: { scope: :country }
  validates :has_farm, inclusion: { in: [true, false] }

  scope :boardable, -> { where(has_farm: true) }
end

# == Schema Information
#
# Table name: locations
# Database name: primary
#
#  id         :bigint           not null, primary key
#  country    :string           not null, uniquely indexed => [name]
#  county     :string
#  has_farm   :boolean          default(TRUE), not null
#  name       :string           not null, uniquely indexed => [country], indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :uuid             indexed
#
# Indexes
#
#  index_locations_on_country_and_name  (country,name) UNIQUE
#  index_locations_on_name              (name)
#  index_locations_on_old_id            (old_id)
#

