require "rails_helper"

RSpec.describe Account::SettingsPolicy do
  subject { described_class.new(Account::User.new, Account::User.new) }

  it { is_expected.to permit_action(:update) }
end

