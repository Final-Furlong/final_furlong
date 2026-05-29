RSpec.describe Users::NewUserForm, type: :model do
  subject(:form) { described_class.new(args) }

  describe "validation" do
    it "uses user validations" do
      form = described_class.new(args.merge(username: ""))

      expect(form).not_to be_valid
      expect(form.errors[:username]).to contain_exactly("can't be blank", "is too short (minimum is 3 characters)")
    end

    it "uses stable validations" do
      form = described_class.new(args.merge(stable_name: ""))

      expect(form).not_to be_valid
      expect(form.errors[:stable_name]).to eq(["can't be blank"])
    end
  end

  it "saves user" do
    form = described_class.new(args)

    expect { form.save }.to change(Account::User, :count).by(1)
  end

  it "saves stable" do
    form = described_class.new(args)

    expect { form.save }.to change(Account::Stable, :count).by(1)
  end

  private

  def args
    user_attrs.merge(stable_attrs)
  end

  def user_attributes
    attributes_for(:user)
  end

  def stable_attributes
    attributes_for(:stable)
  end

  def user_attrs
    {
      username: user_attributes[:username],
      name: user_attributes[:name],
      email: user_attributes[:email]
    }
  end

  def stable_attrs
    {
      stable_name: stable_attributes[:name]
    }
  end
end

