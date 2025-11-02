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
#  country    :string           not null
#  county     :string
#  name       :string           not null, indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :uuid             indexed
#
# Indexes
#
#  index_locations_on_name    (name)
#  index_locations_on_old_id  (old_id)
#

