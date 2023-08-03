require "rails_helper"

RSpec.describe Account::SettingsPolicy do
  subject(:policy) { described_class.new(Account::User.new, user: Account::User.new) }

  describe "#update?" do
    subject { policy.apply(:update?) }

    it { is_expected.to be true }
  end
end

