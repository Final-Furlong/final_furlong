require "rails_helper"

RSpec.describe ApplicationRepository do
  subject(:repo) { described_class.new(model: model) }

  let(:model) { Account::User }

  describe "#find" do
    context "when record cannot be found" do
      it "raises error" do
        expect { repo.find(1) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when record can be found" do
      it "returns record" do
        user = create(:user)
        expect(repo.find(user.id)).to eq user
      end
    end
  end

  describe "#create" do
    context "when attributes are invalid" do
      it "does not create record" do
        attrs = attributes_for(:user)
        attrs.delete(:username)

        expect { repo.create(attrs) }.not_to change(model, :count)
      end
    end

    context "when attributes are valid" do
      it "creates record" do
        attrs = attributes_for(:user)

        expect { repo.create(attrs) }.to change(model, :count).by(1)
      end
    end
  end

  describe "#create!" do
    context "when attributes are invalid" do
      it "raises error" do
        attrs = attributes_for(:user)
        attrs.delete(:username)

        original_user_count = model.count
        expect { repo.create!(attrs) }.to raise_error ActiveRecord::RecordInvalid
        expect(model.count).to eq original_user_count
      end
    end

    context "when attributes are valid" do
      it "creates record" do
        attrs = attributes_for(:user)

        expect { repo.create!(attrs) }.to change(model, :count).by(1)
      end

      it "returns record" do
        attrs = attributes_for(:user)

        expect(repo.create!(attrs)).to be_a model
      end
    end
  end

  describe "#update" do
    let(:user) { create(:user) }

    context "when record cannot be found" do
      it "raises error" do
        attrs = attributes_for(:user)

        expect { repo.update(id: 1, attributes: attrs) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when attributes are invalid" do
      it "does not update record" do
        attrs = { username: "" }

        expect { repo.update(id: user.id, attributes: attrs) }.not_to change(user, :reload)
      end
    end

    context "when attributes are valid" do
      it "updates record" do
        attrs = { username: attributes_for(:user)[:username] }

        expect { repo.update(id: user.id, attributes: attrs) }.to change { user.reload.username }.to(attrs[:username])
      end

      it "returns true" do
        attrs = { username: attributes_for(:user)[:username] }

        expect(repo.update(id: user.id, attributes: attrs)).to be true
      end
    end
  end

  describe "#update!" do
    let(:user) { create(:user) }

    before { user }

    context "when record cannot be found" do
      it "raises error" do
        attrs = attributes_for(:user)

        expect { repo.update!(id: 1, attributes: attrs) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when attributes are invalid" do
      it "raises error" do
        attrs = { username: "" }

        original_attrs = user.attributes.symbolize_keys!
        expect { repo.update!(id: user.id, attributes: attrs) }.to raise_error ActiveRecord::RecordInvalid
        expect(user.reload).to have_attributes(original_attrs.except(:created_at, :confirmed_at, :updated_at))
      end
    end

    context "when attributes are valid" do
      it "updates record" do
        attrs = { username: attributes_for(:user)[:username] }

        expect { repo.update!(id: user.id, attributes: attrs) }.to change { user.reload.username }.to(attrs[:username])
      end

      it "returns true" do
        attrs = { username: attributes_for(:user)[:username] }

        expect(repo.update!(id: user.id, attributes: attrs)).to be true
      end
    end
  end

  describe "#destroy" do
    context "when record cannot be found" do
      it "raises error" do
        expect { repo.destroy(id: 1) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when record can be found" do
      it "destroys record" do
        user = create(:user)
        expect { repo.destroy(user.id) }.to change(model, :count).by(-1)
        expect { user.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end

