RSpec.describe Account::UsersQuery do
  subject(:query) { described_class.new }

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

