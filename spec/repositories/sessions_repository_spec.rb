require "rails_helper"

RSpec.describe SessionsRepository do
  describe ".online" do
    context "when resource has #last_online_at attribute" do
      it "returns false when older than ONLINE_TIME ago" do
        resource = build_stubbed(:stable, last_online_at: Time.current - described_class::ONLINE_TIME - 1.minute)

        expect(described_class.online?(resource:)).to be false
      end

      it "returns true when newer than ONLINE_TIME ago" do
        resource = build_stubbed(:stable, last_online_at: Time.current - described_class::ONLINE_TIME + 1.minute)

        expect(described_class.online?(resource:)).to be true
      end
    end

    context "when resource does not have #last_online_at attribute" do
      it "returns false" do
        resource = build_stubbed(:user)

        expect(described_class.online?(resource:)).to be false
      end
    end
  end
end

# def self.online?(resource:)
#   return false unless resource.last_online_at
#
#   resource.last_online_at >= ONLINE_TIME.ago
# end

