require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:racetracks) }
  end
end
