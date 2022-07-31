require "rails_helper"

RSpec.describe OnlineBadgeComponent, type: :component do
  context "when online" do
    it "renders online badge" do
      render_inline(described_class.new(online: true))

      expect(page).to have_text t("components.online_badge.online")
    end
  end

  context "when offline" do
    it "renders offline badge" do
      render_inline(described_class.new(online: false))

      expect(page).to have_text t("components.online_badge.offline")
    end
  end
end
