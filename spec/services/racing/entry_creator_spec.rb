RSpec.describe Racing::EntryCreator do
  describe "#create_entry" do
    let(:params) { { race:, horse:, stable: } }

    shared_examples "an entry without errors" do
      it "does not return error" do
        result = described_class.new.create_entry(**params)
        expect(result.error).to be_nil
      end

      it "creates a race entry" do
        expect { described_class.new.create_entry(**params) }.to change(Racing::RaceEntry, :count).by(1)
      end
    end

    shared_examples "an entry with errors" do
      it "does not create a race entry" do
        expect { described_class.new.create_entry(**params) }.not_to change(Racing::RaceEntry, :count)
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
        expect(Racing::RaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, equipment: 0, post_parade: 0, racing_style: nil,
          weight: 0, jockey: nil, first_jockey: nil, second_jockey: nil, third_jockey: nil, odd: nil
        )
      end
    end

    context "with jockey choices" do
      let(:params) { { race:, horse:, stable:, first_jockey:, second_jockey:, third_jockey: } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::RaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, equipment: 0, post_parade: 0, racing_style: nil,
          weight: 0, jockey: nil, first_jockey:, second_jockey:, third_jockey:, odd: nil
        )
      end
    end

    context "with racing style" do
      let(:params) { { race:, horse:, stable:, racing_style: } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::RaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, equipment: 0, post_parade: 0, racing_style:,
          weight: 0, jockey: nil, first_jockey: nil, second_jockey: nil, third_jockey: nil, odd: nil
        )
      end
    end

    context "with equipment selected" do
      let(:params) { { race:, horse:, stable:, equipment: 1 } }

      it_behaves_like "an entry without errors"

      it "sets correct data on entry" do
        described_class.new.create_entry(**params)
        expect(Racing::RaceEntry.find_by(horse:)).to have_attributes(
          date: race.date, horse:, race:, equipment: 1, post_parade: 0, racing_style: nil,
          weight: 0, jockey: nil, first_jockey: nil, second_jockey: nil, third_jockey: nil, odd: nil
        )
      end
    end

    context "when entries have closed" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.deadline_past") }

        before { race.update(date: Date.current) }
      end
    end

    context "when entries are not yet open" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.entries_not_open") }

        before { race.update(date: Date.current + 10.days) }
      end
    end

    context "when horse is leased and stable is owner" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.stable_not_manager") }

        before { create(:lease, horse:, leaser: create(:stable)) }
      end
    end

    context "when horse is not owned by stable (and not leased)" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.stable_not_manager") }
        let(:stable) { create(:stable) }
      end
    end

    context "when horse is not a racehorse" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.horse_not_racehorse") }

        before { horse.update(status: "retired") }
      end
    end

    context "when race is a flat race" do
      context "when horse is a jumper" do
        it_behaves_like "an entry with errors" do
          let(:error) { I18n.t("services.races.entry_creator.horse_not_flat") }

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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

          let(:error) { I18n.t("services.races.entry_creator.horse_not_qualified", name: horse.name) }
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

    context "when horse is not at the track" do
      context "when horse can ship to the track in time" do
        context "when stable cannot afford shipping + entry fee" do
          it_behaves_like "an entry with errors" do
            let(:error) { I18n.t("services.races.entry_creator.cannot_afford_entry") }
            let(:params) { { race:, horse:, stable:, ship_mode: "road" } }

            before do
              other_racetrack = create(:racetrack)
              horse.race_metadata.update(racetrack: other_racetrack, location: other_racetrack.location)
              horse_location = other_racetrack.location
              race_location = race.racetrack.location
              create(:shipping_route, starting_location: horse_location, ending_location: race_location, road_cost: 1000)
              stable.update(available_balance: race.entry_fee + 500)
            end
          end

          it "does not ship the horse" do
            expect { described_class.new.create_entry(**params) }.not_to change(Shipping::RacehorseShipment, :count)
          end
        end

        context "when stable can afford shipping + entry fee" do
          let(:params) { { race:, horse:, stable:, ship_mode: "road" } }

          before do
            other_racetrack = create(:racetrack)
            horse.race_metadata.update(racetrack: other_racetrack, location: other_racetrack.location)
            horse_location = other_racetrack.location
            stable.update(racetrack: other_racetrack)
            race_location = race.racetrack.location
            create(:shipping_route, starting_location: horse_location, ending_location: race_location, road_cost: 1000)
          end

          it_behaves_like "an entry without errors"

          it "does ship the horse" do
            expect { described_class.new.create_entry(**params) }.to change(Shipping::RacehorseShipment, :count)
          end
        end

        context "when stable can afford shipping + entry fee but shipping mode is missing" do
          let(:params) { { race:, horse:, stable: } }

          before do
            other_racetrack = create(:racetrack)
            horse.race_metadata.update(racetrack: other_racetrack, location: other_racetrack.location)
            horse_location = other_racetrack.location
            race_location = race.racetrack.location
            create(:shipping_route, starting_location: horse_location, ending_location: race_location, road_cost: 1000)
          end

          it_behaves_like "an entry with errors" do
            let(:error) { I18n.t("services.races.entry_creator.horse_needs_shipping", name: horse.name) }
          end

          it "does not ship the horse" do
            expect { described_class.new.create_entry(**params) }.not_to change(Shipping::RacehorseShipment, :count)
          end
        end
      end

      context "when horse cannot ship to the track in time" do
        it_behaves_like "an entry with errors" do
          let(:error) { I18n.t("services.races.entry_creator.horse_cannot_ship_in_time", name: horse.name) }
          let(:params) { { race:, horse:, stable:, ship_mode: "road" } }

          before do
            other_racetrack = create(:racetrack)
            horse.race_metadata.update(racetrack: other_racetrack, location: other_racetrack.location)
            horse_location = other_racetrack.location
            race_location = race.racetrack.location
            create(:shipping_route, starting_location: horse_location, ending_location: race_location, road_cost: 1000, road_days: 10)
          end
        end

        it "does not ship the horse" do
          expect { described_class.new.create_entry(**params) }.not_to change(Shipping::RacehorseShipment, :count)
        end
      end
    end

    context "when horse is boarded" do
      let(:boarding) { create(:boarding, horse:, start_date: 20.days.ago, end_date: nil) }

      before { boarding }

      context "when stable cannot afford boarding + entry fee" do
        it_behaves_like "an entry with errors" do
          let(:error) { I18n.t("services.races.entry_creator.cannot_afford_entry") }

          before { stable.update(available_balance: race.entry_fee + 500) }
        end

        it "does not stop boarding" do
          expect { described_class.new.create_entry(**params) }.not_to change { boarding }
        end
      end

      context "when stable can afford boarding + entry fee" do
        it_behaves_like "an entry without errors"

        it "does stop boarding" do
          described_class.new.create_entry(**params)
          expect(boarding.reload.end_date).not_to be_nil
        end
      end
    end

    context "when horse is already entered to race on this day" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.horse_has_entry", name: horse.name) }

        before do
          other_race = race.dup
          other_race.update(number: race.number + 1)
          create(:race_entry, horse:, race: other_race)
        end
      end
    end

    context "when stable cannot afford entry fee" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.cannot_afford_entry") }

        before { stable.update(available_balance: race.entry_fee - 500) }
      end
    end

    context "when stable has max entries in the race" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.max_entries_stable") }

        before do
          create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
          create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
        end
      end

      context "when limit is increased by 1" do
        it_behaves_like "an entry with errors" do
          let(:error) { I18n.t("services.races.entry_creator.max_entries_stable") }

          before do
            create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
            create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
            create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
          end
        end
      end
    end

    context "when stable has less than max extra entries in the race" do
      it_behaves_like "an entry without errors" do
        before do
          create(:race_entry, race:, horse: create(:horse, :racehorse, owner: stable))
        end
      end
    end

    context "when race is full" do
      it_behaves_like "an entry with errors" do
        let(:error) { I18n.t("services.races.entry_creator.max_entries") }

        before { create_list(:race_entry, 14, race:) }
      end
    end

    context "when race requires qualification" do
      context "when horse is qualified" do
        pending "set up race qualifications" do
          it_behaves_like "an entry without errors"
        end
      end

      context "when horse is not qualified" do
        pending "set up race qualifications" do
          it_behaves_like "an entry with errors"
        end
      end
    end
  end

  private

  def race
    @race ||= create(:race_schedule, date: Date.current + 5.days, age: "3")
  end

  def horse
    return @horse if defined?(@horse)

    @horse = create(:horse, :racehorse)
    @race_option = create(:race_option, horse: @horse)
    @race_metadata = create(:racehorse_metadata, horse: @horse, racetrack: race.racetrack, location: race.racetrack.location)
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

