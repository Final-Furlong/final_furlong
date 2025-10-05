RSpec.describe Racing::TrackSurface do
  describe "associations" do
    it { is_expected.to belong_to(:racetrack) }
  end
end

