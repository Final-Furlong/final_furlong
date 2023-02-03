require "rails_helper"

RSpec.describe Account::UsersRepository do
  describe "#active" do
    it "returns value from model" do
      expect(described_class.new(model: Account::User).active).to eq Account::User.active
    end
  end
end

