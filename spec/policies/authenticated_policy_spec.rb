require "rails_helper"

class FakePolicy < AuthenticatedPolicy
  def show?
    true
  end
end

RSpec.describe AuthenticatedPolicy do
  subject(:policy) { FakePolicy.new(Account::User.new, user:) }

  let(:user) { Account::User.new }

  describe "#show?" do
    context "when user is set" do
      it "does not raise error" do
        expect(policy.apply(:show?)).to be true
      end
    end

    context "when user is not set" do
      let(:user) { nil }

      it "raises error" do
        expect(policy.apply(:show?)).to be false
      end
    end
  end
end

