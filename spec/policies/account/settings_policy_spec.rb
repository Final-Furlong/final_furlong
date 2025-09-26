require "rails_helper"

RSpec.describe Account::SettingsPolicy do
  subject(:policy) { described_class.new(Account::User.new, user: Account::User.new) }

  describe "#create?" do
    subject { policy.apply(:create?) }

    it { is_expected.to be true }
  end
end

