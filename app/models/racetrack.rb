class Racetrack < ApplicationRecord
  validates :name, presence: true, length: { minimum: 4 }
  validates :name, uniqueness: { case_sensitive: false }

  validates :country, presence: true, length: { minimum: 4 }
  validates :longitude, presence: true,
                        numericality: { less_than_or_equal_to: 180, greater_than_or_equal_to: -180 }
  validates :latitude, presence: true,
                       numericality: { less_than_or_equal_to: 90, greater_than_or_equal_to: -90 }
end

# == Schema Information
#
# Table name: racetracks
#
#  id         :bigint           not null, primary key
#  country    :string           indexed
#  latitude   :decimal(, )      indexed
#  longitude  :decimal(, )      indexed
#  name       :string           indexed
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_racetracks_on_country    (country)
#  index_racetracks_on_latitude   (latitude)
#  index_racetracks_on_longitude  (longitude)
#  index_racetracks_on_name       (name) UNIQUE
#
