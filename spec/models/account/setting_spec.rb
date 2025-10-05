RSpec.describe Account::Setting do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end
end

