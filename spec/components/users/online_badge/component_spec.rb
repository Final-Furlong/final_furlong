RSpec.describe Users::OnlineBadge::Component, type: :component do
  context "when online" do
    it "renders online badge" do
      render_inline(described_class.new(online: true))

      expect(page).to have_text t("view_components.users.online_badge.online")
    end
  end

  context "when offline" do
    it "renders offline badge" do
      render_inline(described_class.new(online: false))

      expect(page).to have_text t("view_components.users.online_badge.offline")
    end
  end
end

