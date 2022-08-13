require "rails_helper"

RSpec.describe AuthenticatedPolicy do
  subject(:policy) { described_class.new(user, User.new) }

  let(:user) { User.new }

  describe "#initialize" do
    context "when user is set" do
      it "does not raise error" do
        expect { policy }.not_to raise_error
      end
    end

    context "when user is not set" do
      let(:user) { nil }

      it "raises error" do
        expect { policy }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe "::Scope" do
    describe "#initialize" do
      it "does not raise error when user is set" do
        expect do
          described_class::Scope.new(user, User.all)
        end.not_to raise_error
      end

      it "raises error when user is not set" do
        expect do
          described_class::Scope.new(nil, User.all)
        end.to raise_error Pundit::NotAuthorizedError
      end
    end
  end
end

