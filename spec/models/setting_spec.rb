require "rails_helper"

RSpec.describe Setting do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end

