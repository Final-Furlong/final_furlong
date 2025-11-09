RSpec.describe Notification do
  describe "associations" do
    it { is_expected.to belong_to(:user).class_name("Account::User") }
  end

  describe "scopes" do
    describe ".read" do
      it "returns correct records" do
        read = described_class.create(user:, read_at: DateTime.current)
        unread = described_class.create(user:, read_at: nil)

        result = described_class.read
        expect(result).to include read
        expect(result).not_to include unread
      end
    end

    describe ".unread" do
      it "returns correct records" do
        read = described_class.create(user:, read_at: DateTime.current)
        unread = described_class.create(user:, read_at: nil)

        result = described_class.unread
        expect(result).to include unread
        expect(result).not_to include read
      end
    end

    describe ".param_equals" do
      it "returns correct records" do
        matching = described_class.create(user:, params: { foo: "bar" })
        non_matching = described_class.create(user:, params: { foo: "baz" })
        non_matching2 = described_class.create(user:, params: { abc: "bar" })

        result = described_class.param_equals("foo", "bar")
        expect(result).to include matching
        expect(result).not_to include non_matching, non_matching2
      end
    end
  end

  describe "#to_partial_path" do
    it "returns notifications partial" do
      notification = described_class.build(user:, params: { foo: "bar" })
      expect(notification.to_partial_path).to eq "notifications/notification"
    end
  end

  describe "#read?" do
    context "when read_at has a value" do
      it "returns true" do
        notification = described_class.build(read_at: DateTime.current)
        expect(notification.read?).to be true
      end
    end

    context "when read_at is blank" do
      it "returns false" do
        notification = described_class.build(read_at: nil)
        expect(notification.read?).to be false
      end
    end
  end

  describe "#title" do
    it "returns default value" do
      notification = described_class.new
      expect(notification.title).to eq I18n.t("notifications.notification.title")
    end
  end

  describe "#actions" do
    it "returns default value" do
      notification = described_class.new
      expect(notification.actions).to eq([])
    end
  end

  private

  def user
    @user ||= create(:user)
  end
end

