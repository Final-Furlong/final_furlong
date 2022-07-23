RSpec.describe Stable, type: :model do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }

    it "owns horses" do
      expect(stable).to have_many(:horses).inverse_of(:owner)
    end

    it "breeds horses" do
      expect(stable).to have_many(:bred_horses).inverse_of(:breeder)
    end
  end
end

# == Schema Information
#
# Table name: stables
#
#  id          :uuid             not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null, indexed
#  updated_at  :datetime         not null
#  legacy_id   :integer          indexed
#  user_id     :uuid             not null, indexed
#
# Indexes
#
#  index_stables_on_created_at  (created_at)
#  index_stables_on_legacy_id   (legacy_id)
#  index_stables_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
