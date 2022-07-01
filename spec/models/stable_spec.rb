# typed: false

RSpec.describe Stable, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(100) }
  end

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
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           indexed
#
# Indexes
#
#  index_stables_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
