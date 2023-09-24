require "rails_helper"

RSpec.describe Account::UsersQuery do
  subject(:query) { described_class.new }

  describe ".ordered" do
    it "orders by created timestamp descending" do
      user1 = create(:user, created_at: 5.minutes.ago)
      user2 = create(:user, created_at: 10.minutes.ago)
      user3 = create(:user)

      expect(query.ordered).to eq([user3, user1, user2])
    end
  end
end

