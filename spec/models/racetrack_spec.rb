# typed: false

require "rails_helper"

RSpec.describe Racetrack, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(4) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_length_of(:country).is_at_least(4) }

    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }
    it { is_expected.to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }

    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }
    it { is_expected.to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }
  end
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
