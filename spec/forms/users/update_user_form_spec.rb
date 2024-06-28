require "rails_helper"

RSpec.describe Users::UpdateUserForm, type: :model do
  subject(:form) { described_class.new(user) }

  let(:user) { create(:user) }

  describe "validation" do
    it "uses user validations" do
      form.submit(name: "", email: "test@test.com")

      expect(form).not_to be_valid
      expect(form.errors[:name]).to eq(["can't be blank"])
    end
  end

  it "updates user" do
    form.submit(name: "New Name", email: "test@test.com")
    expect(user.reload).to have_attributes(name: "New Name")
  end
end

