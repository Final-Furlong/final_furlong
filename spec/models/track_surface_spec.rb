require "rails_helper"

RSpec.describe TrackSurface do
  describe "associations" do
    it { is_expected.to belong_to(:racetrack) }
  end
end

