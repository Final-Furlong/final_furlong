RSpec.describe Racing::FutureEntryCreator do
  describe "#create_entry" do
    let(:params) { { race:, horse:, stable: } }

    shared_examples "an entry without errors" do
      it "does not return error" do
        result = described_class.new.create_entry(**params)
        expect(result.error).to be_nil
      end

      it "creates a race entry" do
        expect { described_class.new.create_entry(**params) }.to change(Racing::FutureRaceEntry, :count).by(1)
      end
    end

    shared_examples "an entry with errors" do
      it "does not create a race entry" do
        expect { described_class.new.create_entry(**params) }.not_to change(Racing::FutureRaceEntry, :count)
      end

      it "returns error" do
        result = described_class.new.create_entry(**params)
        expect(result.error).to eq error
      end
    end

    context "with minimal params" do
      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::FutureRaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, stable:, equipment: 0, racing_style: nil,
          first_jockey: nil, second_jockey: nil, third_jockey: nil,
          auto_enter: false, auto_ship: false, ship_date: nil, ship_mode: "",
          ship_only_if_horse_is_entered: false, ship_when_entries_open: false,
          ship_when_horse_is_entered: false
        )
      end
    end

    context "with jockey choices" do
      let(:params) { { race:, horse:, stable:, first_jockey:, second_jockey:, third_jockey: } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::FutureRaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, stable:, equipment: 0, racing_style: nil,
          first_jockey:, second_jockey:, third_jockey:,
          auto_enter: false, auto_ship: false, ship_date: nil, ship_mode: "",
          ship_only_if_horse_is_entered: false, ship_when_entries_open: false,
          ship_when_horse_is_entered: false
        )
      end
    end

    context "with racing style" do
      let(:params) { { race:, horse:, stable:, racing_style: } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::FutureRaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, stable:, equipment: 0, racing_style:,
          first_jockey: nil, second_jockey: nil, third_jockey: nil,
          auto_enter: false, auto_ship: false, ship_date: nil, ship_mode: "",
          ship_only_if_horse_is_entered: false, ship_when_entries_open: false,
          ship_when_horse_is_entered: false
        )
      end
    end

    context "with equipment selected" do
      let(:params) { { race:, horse:, stable:, blinkers: 1 } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::FutureRaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, stable:, equipment: 1, racing_style: nil,
          first_jockey: nil, second_jockey: nil, third_jockey: nil,
          auto_enter: false, auto_ship: false, ship_date: nil, ship_mode: "",
          ship_only_if_horse_is_entered: false, ship_when_entries_open: false,
          ship_when_horse_is_entered: false, blinkers: true
        )
      end
    end

    context "when horse is leased and stable is owner" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.future_entry_creator.stable_not_manager") }

        before do
          leaser = create(:stable)
          create(:lease, horse:, leaser:)
          horse.update(manager: leaser)
        end
      end
    end

    context "when horse is not owned by stable (and not leased)" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.future_entry_creator.stable_not_manager") }
        let(:stable) { create(:stable) }
      end
    end

    context "when horse is not a racehorse" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.future_entry_creator.horse_not_racehorse") }

        before { horse.update(status: "retired") }
      end
    end

    context "when race is a flat race" do
      context "when horse is a jumper" do
        it_behaves_like "an entry with errors" do
          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_flat") }

          before do
            horse
            @race_option.update(racehorse_type: "jump")
          end
        end
      end

      context "when horse is not a jumper" do
        it_behaves_like "an entry without errors"
      end
    end

    context "when race is a jump race" do
      context "when horse is a jumper" do
        before do
          horse.race_options.update(racehorse_type: "jump")
          racetrack = race.racetrack
          race.update(track_surface: create(:track_surface, :jump, racetrack:))
        end

        it_behaves_like "an entry without errors"
      end
    end

    context "when race is for maidens" do
      context "when horse is not maiden qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1)
            race.update(race_type: "maiden")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is maiden qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 2)
            race.update(race_type: "maiden")
            refresh_views
          end
        end
      end
    end

    context "when race is a claimer" do
      context "when horse is not claimer qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:horse_sale, horse:, date: 1.day.ago)
            race.update(race_type: "claiming")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is claimer qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, race: create(:race_result, date: 1.week.ago))
            create(:race_result_horse, horse:, race: create(:race_result, date: 4.days.ago))
            create(:race_result_horse, horse:, race: create(:race_result, date: 1.day.ago))
            race.update(race_type: "claiming")
            refresh_views
          end
        end
      end
    end

    context "when race is a starter allowance" do
      context "when horse is not SA qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:race_result_horse, horse:, race: create(:race_result, date: 1.week.ago, race_type: "maiden"))
            race.update(race_type: "starter_allowance")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is SA qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, race: create(:race_result, date: 1.week.ago, race_type: "claiming", claiming_price: 5000))
            race.update(race_type: "starter_allowance")
            refresh_views
          end
        end
      end
    end

    context "when race is a NW1 allowance" do
      context "when horse is not NW1 qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            race.update(race_type: "nw1_allowance")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is NW1 qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "maiden"))
            race.update(race_type: "nw1_allowance")
            refresh_views
          end
        end
      end
    end

    context "when race is a NW2 allowance" do
      context "when horse is not NW2 qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            race.update(race_type: "nw2_allowance")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is NW2 qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "maiden"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            race.update(race_type: "nw2_allowance")
            refresh_views
          end
        end
      end
    end

    context "when race is a NW3 allowance" do
      context "when horse is not NW3 qualified" do
        it_behaves_like "an entry with errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            race.update(race_type: "nw3_allowance")
            refresh_views
          end

          let(:error) { I18n.t("services.races.future_entry_creator.horse_not_qualified", name: horse.name) }
        end
      end

      context "when horse is NW3 qualified" do
        it_behaves_like "an entry without errors" do
          before do
            horse
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "maiden"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
            race.update(race_type: "nw3_allowance")
            refresh_views
          end
        end
      end
    end

    context "when race is an allowance" do
      it_behaves_like "an entry without errors" do
        before do
          horse
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "stakes", grade: "Ungraded", name: "A Stakes"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          race.update(race_type: "allowance")
          refresh_views
        end
      end
    end

    context "when race is a stakes" do
      it_behaves_like "an entry without errors" do
        before do
          horse
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "stakes", grade: "Ungraded", name: "A Stakes"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          create(:race_result_horse, horse:, finish_position: 1, race: create(:race_result, race_type: "allowance"))
          race.update(race_type: "stakes", grade: "Ungraded", name: "A Stakes")
          refresh_views
        end
      end
    end

    context "when horse has a scheduled entered to race on this day" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.future_entry_creator.horse_has_entry", name: horse.name) }

        before do
          other_race = race.dup
          other_race.update(number: race.number + 1)
          create(:future_race_entry, horse:, race: other_race)
        end
      end
    end

    context "when stable has max scheduled entries in the race" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.future_entry_creator.max_entries_stable") }

        before do
          create(:future_race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
          create(:future_race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
        end
      end
    end

    context "when stable has less than max extra entries in the race" do
      it_behaves_like "an entry without errors" do
        before do
          create(:future_race_entry, race:, horse: create(:horse, :racehorse))
        end
      end
    end

    context "when race requires qualification" do
      context "when horse is qualified" do
        it_behaves_like "an entry without errors"
      end

      context "when horse is not qualified" do
        it "will not work"
      end
    end
  end

  private

  def race
    @race ||= create(:race_schedule, date: Date.current + 15.days, age: "3")
  end

  def horse
    return @horse if defined?(@horse)

    @horse = create(:horse, :racehorse)
    @race_option = create(:race_option, horse: @horse)
    horse.race_metadata.update(racetrack: race.racetrack, location: race.racetrack.location)
    refresh_views
    @horse
  end

  def refresh_views
    Racing::RaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
    Racing::RaceQualification.refresh
  end

  def stable
    return @stable if defined?(@stable) && @stable.available_balance.positive?

    @stable = horse.owner
    @stable.update(available_balance: 10_000)
    @stable
  end

  def first_jockey
    @first_jockey ||= create(:jockey)
  end

  def second_jockey
    @second_jockey ||= create(:jockey)
  end

  def third_jockey
    @third_jockey ||= create(:jockey)
  end

  def racing_style
    @racing_style ||= Config::Racing.styles.sample
  end
end

