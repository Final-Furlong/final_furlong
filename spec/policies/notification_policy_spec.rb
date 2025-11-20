RSpec.describe NotificationPolicy do
  subject(:policy) { described_class.new(user, notification) }

  let(:user) { build_stubbed(:user) }
  let(:notification) { Notification.new }

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow anything" do
      notification.user = build(:user)
      expect(policy).not_to permit_actions(:update)
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }

    context "when user is tied to the notification" do
      it "allows update" do
        notification.update(user:)
        expect(policy).to permit_action(:update)
      end
    end

    context "when user is not tied to the notification" do
      it "does not allow update" do
        notification.update(user: create(:user))
        expect(policy).not_to permit_action(:update)
      end
    end
  end
end

