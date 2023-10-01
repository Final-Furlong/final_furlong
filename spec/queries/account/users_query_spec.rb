require "rails_helper"

RSpec.describe Account::UsersQuery do
  subject(:query) { described_class.new }

  describe ".ordered" do
    it "orders by created timestamp descending" do
      user1 = create(:user, created_at: 5.minutes.ago)
      user2 = create(:user, created_at: 10.minutes.ago)
      user3 = create(:user)

      expect(query.ordered.to_a).to eq([user3, user1, user2])
    end
  end

  describe ".active" do
    it "returns active users only" do
      active_user = create(:user, :active)
      pending_user = create(:user, :pending)
      deleted_user = create(:user, :deleted)
      banned_user = create(:user, :banned)

      result = query.active
      expect(result).to include active_user
      expect(result).not_to include pending_user, deleted_user, banned_user
    end
  end
end

