require "rails_helper"

RSpec.describe UsersRepository do
  describe "#active" do
    it "returns value from model" do
      expect(described_class.new(model: User).active).to eq User.active
    end
  end
end

