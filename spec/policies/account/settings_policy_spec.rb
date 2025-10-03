require "rails_helper"

RSpec.describe Account::SettingsPolicy do
  subject(:policy) { described_class.new(Account::User.new, user: Account::User.new) }

  it { is_expected.to permit_action(:create) }
end

