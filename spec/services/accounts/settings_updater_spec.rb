RSpec.describe Accounts::SettingsUpdater do
  describe "#call" do
    context "with user" do
      before { allow(Current).to receive(:user).and_return user }

      it "returns updated true" do
        result = described_class.new.call(params:, cookies:)
        expect(result.updated?).to be true
      end

      it "returns locale" do
        result = described_class.new.call(params:, cookies:)
        expect(result.locale).to eq params[:website_attributes][:locale]
      end

      it "returns no error" do
        result = described_class.new.call(params:, cookies:)
        expect(result.error).to be_nil
      end

      it "creates user settings" do
        expect { described_class.new.call(params:, cookies:) }.to change(Account::Setting, :count).by(1)
      end

      it "saves website settings" do
        described_class.new.call(params:, cookies:)
        setting = Account::Setting.last
        expect(setting.website).to have_attributes(
          locale: "en-GB",
          light_theme: "nord",
          dark_theme: "night",
          mode: "light"
        )
      end

      it "saves racing settings" do
        described_class.new.call(params:, cookies:)
        setting = Account::Setting.last
        expect(setting.racing).to have_attributes(
          min_days_delay_from_last_race: 10,
          min_days_delay_from_last_injury: 5,
          min_days_rest_between_races: 5,
          min_workouts_between_races: 5,
          apply_minimums_for_future_races: false,
          min_energy_for_race_entry: "B"
        )
      end

      it "saves time zone" do
        described_class.new.call(params:, cookies:)
        setting = Account::Setting.last
        expect(setting).to have_attributes(user:, time_zone: "America/New_York")
      end

      it "saves permanent cookies" do
        expect(cookies.permanent).to eq({})
        described_class.new.call(params:, cookies:)
        expect(cookies.permanent).to eq({
          locale: params[:website_attributes][:locale],
          mode: params[:website_attributes][:mode],
          dark_theme: params[:website_attributes][:dark_theme],
          light_theme: params[:website_attributes][:light_theme]
        })
      end

      context "when only given website settings" do
        let(:website_params) { { website_attributes: params[:website_attributes] } }

        it "saves website settings" do
          described_class.new.call(params: website_params, cookies:)
          setting = Account::Setting.last
          expect(setting.website).to have_attributes(
            locale: "en-GB",
            light_theme: "nord",
            dark_theme: "night",
            mode: "light"
          )
        end

        it "saves permanent cookies" do
          expect(cookies.permanent).to eq({})
          described_class.new.call(params: website_params, cookies:)
          expect(cookies.permanent).to eq({
            locale: params[:website_attributes][:locale],
            mode: params[:website_attributes][:mode],
            dark_theme: params[:website_attributes][:dark_theme],
            light_theme: params[:website_attributes][:light_theme]
          })
        end

        it "handles missing locale" do
          website_params[:website_attributes].delete(:locale)
          described_class.new.call(params: website_params, cookies:)
          expect(Account::Setting.last.website).to have_attributes(locale: I18n.default_locale.to_s)
          expect(cookies.permanent[:locale]).to eq I18n.default_locale.to_s
        end

        it "handles missing light theme" do
          website_params[:website_attributes].delete(:light_theme)
          described_class.new.call(params: website_params, cookies:)
          expect(Account::Setting.last.website).to have_attributes(light_theme: nil)
          expect(cookies.permanent[:light_theme]).to be_nil
        end

        it "handles missing dark theme" do
          website_params[:website_attributes].delete(:dark_theme)
          described_class.new.call(params: website_params, cookies:)
          expect(Account::Setting.last.website).to have_attributes(dark_theme: nil)
          expect(cookies.permanent[:dark_theme]).to be_nil
        end

        it "handles missing mode" do
          website_params[:website_attributes].delete(:mode)
          described_class.new.call(params: website_params, cookies:)
          expect(Account::Setting.last.website).to have_attributes(mode: nil)
          expect(cookies.permanent[:mode]).to be_nil
        end
      end

      context "when only given racing settings" do
        let(:racing_params) {
          { racing_attributes: params[:racing_attributes] }
        }

        it "saves racing settings" do
          described_class.new.call(params: racing_params, cookies:)
          setting = Account::Setting.last
          expect(setting.racing).to have_attributes(
            min_days_delay_from_last_race: 10,
            min_days_delay_from_last_injury: 5,
            min_days_rest_between_races: 5,
            min_workouts_between_races: 5,
            apply_minimums_for_future_races: false,
            min_energy_for_race_entry: "B"
          )
        end

        it "handles missing energy grade" do
          racing_params[:racing_attributes].delete(:min_energy_for_race_entry)
          described_class.new.call(params: racing_params, cookies:)
          expect(Account::Setting.last.racing).to have_attributes(min_energy_for_race_entry: nil)
        end
      end

      context "when settings saving fails" do
        it "returns error" do
          new_params = params.dup
          new_params[:website_attributes][:locale] = "fr"
          result = described_class.new.call(params: new_params, cookies:)
          expect(result.error).to eq "Website is invalid"
        end

        it "returns updated false" do
          new_params = params.dup
          new_params[:website_attributes][:locale] = "fr"
          result = described_class.new.call(params: new_params, cookies:)
          expect(result.updated?).to be false
        end
      end
    end

    context "without user" do
      let(:cookies) { {} }

      it "returns locale" do
        result = described_class.new.call(params:, cookies:)
        expect(result.locale).to eq params[:website_attributes][:locale]
      end

      it "returns updated true" do
        result = described_class.new.call(params:, cookies:)
        expect(result.updated?).to be true
      end

      it "saves temporary cookies" do
        described_class.new.call(params:, cookies:)
        expect(cookies).to eq({ locale: params[:website_attributes][:locale] })
      end

      it "does not save settings" do
        expect { described_class.new.call(params:, cookies:) }.not_to change(Account::Setting, :count)
      end
    end
  end

  private

  def params
    {
      website_attributes: {
        locale: "en-GB",
        light_theme: "nord",
        dark_theme: "night",
        mode: "light"
      },
      racing_attributes: {
        min_days_delay_from_last_race: 10,
        min_days_delay_from_last_injury: 5,
        min_days_rest_between_races: 5,
        min_workouts_between_races: 5,
        apply_minimums_for_future_races: false,
        min_energy_for_race_entry: "B"
      },
      time_zone: "America/New_York"
    }
  end

  def user
    @user ||= create(:user)
  end

  def cookies
    @cookies ||= instance_double(ActionDispatch::Cookies::CookieJar, permanent: {})
  end
end

