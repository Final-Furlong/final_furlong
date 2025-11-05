RSpec.describe Location do
  describe "associations" do
    it { is_expected.to have_one(:racetrack) }
  end
end

