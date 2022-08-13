require "rails_helper"

RSpec.describe SettingsPolicy do
  subject { described_class.new(User.new, User.new) }

  it { is_expected.to permit_action(:update) }
end

