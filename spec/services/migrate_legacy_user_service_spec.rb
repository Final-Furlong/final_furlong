require "rails_helper"

# rubocop:disable RSpec/ExampleLength
RSpec.describe MigrateLegacyUserService do
  subject(:migrate) { described_class.new(id) }

  context "when legacy user cannot be found" do
    let(:id) { 1 }

    it "does not create a user" do
      user_count = Account::User.count
      expect { migrate.call }.to raise_error ActiveRecord::RecordNotFound

      expect(user_count).to eq Account::User.count
    end

    it "does not create a stable" do
      stable_count = Account::Stable.count
      expect { migrate.call }.to raise_error ActiveRecord::RecordNotFound

      expect(stable_count).to eq Account::Stable.count
    end

    it "returns error" do
      expect { migrate.call }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context "when legacy user can be found" do
    let(:legacy_user) { create(:legacy_user) }
    let(:id) { legacy_user.id }

    context "when user exists" do
      let(:user) { create(:user, email: legacy_user.email, stable: nil) }
      let(:stable) { create(:stable, user:) }

      before { stable }

      it "does not create user" do
        expect { migrate.call }.not_to change(Account::User, :count)
      end

      it "does not create stable" do
        expect { migrate.call }.not_to change(Account::Stable, :count)
      end

      it "does not change user" do
        expect { migrate.call }.not_to change(user, :reload)
      end

      it "does not change stable" do
        expect { migrate.call }.not_to change(stable, :reload)
      end

      it "does not error" do
        expect { migrate.call }.not_to raise_error
      end
    end

    context "when user does not exist" do
      it "creates user" do
        expect { migrate.call }.to change(Account::User, :count).by(1)
      end

      it "creates stable" do
        expect { migrate.call }.to change(Account::Stable, :count).by(1)
      end

      it "assigns correct attributes to stable" do
        result = migrate.call

        expect(result.stable).to have_attributes(
          legacy_id: legacy_user.id,
          name: legacy_user.stable_name,
          user_id: anything
        )
        expect(result.stable.created_at).to eq legacy_user.join_date - 4.years
      end

      it "assigns correct attributes to user for active stable" do
        legacy_user.update!(Status: "A")
        result = migrate.call

        expect(result).to have_attributes(
          admin: false,
          confirmed_at: anything,
          email: legacy_user.email,
          last_sign_in_at: nil,
          last_sign_in_ip: legacy_user.ip,
          name: legacy_user.name,
          status: Account::User.statuses[:pending],
          unconfirmed_email: legacy_user.email,
          username: legacy_user.username,
          created_at: legacy_user.join_date - 4.years,
          updated_at: anything,
          discourse_id: legacy_user.discourse_id,
          password: anything,
          password_confirmation: anything,
          discarded_at: nil
        )
      end

      it "assigns correct attributes to user for color war stable" do
        legacy_user.update!(Status: "CW")
        result = migrate.call

        expect(result).to have_attributes(
          admin: false,
          confirmed_at: anything,
          email: legacy_user.email,
          last_sign_in_at: legacy_user.last_login,
          last_sign_in_ip: legacy_user.ip,
          name: legacy_user.name,
          status: Account::User.statuses[:active],
          unconfirmed_email: legacy_user.email,
          username: legacy_user.username,
          created_at: legacy_user.join_date - 4.years,
          updated_at: anything,
          discourse_id: legacy_user.discourse_id,
          password: anything,
          password_confirmation: anything,
          discarded_at: nil
        )
      end

      it "assigns correct attributes to user for deleted stable" do
        legacy_user.update!(Status: "D")
        result = migrate.call

        expect(result).to have_attributes(
          admin: false,
          confirmed_at: anything,
          email: legacy_user.email,
          last_sign_in_at: legacy_user.last_login,
          last_sign_in_ip: legacy_user.ip,
          name: legacy_user.name,
          status: Account::User.statuses[:deleted],
          unconfirmed_email: legacy_user.email,
          username: legacy_user.username,
          created_at: legacy_user.join_date - 4.years,
          updated_at: anything,
          discourse_id: legacy_user.discourse_id,
          password: anything,
          password_confirmation: anything,
          discarded_at: anything
        )
      end

      it "returns user" do
        result = migrate.call

        expect(result).to be_a Account::User
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength

