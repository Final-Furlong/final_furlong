describe Horses::Horse do
  describe "associations" do
    subject(:horse) { build_stubbed(:horse) }

    it { is_expected.to belong_to(:breeder).class_name("Account::Stable") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:sire).class_name("Horses::Horse::Stud").optional }
    it { is_expected.to belong_to(:dam).class_name("Horses::Horse::Broodmare").optional }
    it { is_expected.to belong_to(:location_bred).class_name("Location") }

    it { is_expected.to have_one(:appearance).class_name("Horses::Appearance").dependent(:delete) }
    it { is_expected.to have_one(:genetics).class_name("Horses::Genetics").dependent(:delete) }
    it { is_expected.to have_one(:auction_horse).class_name("Auctions::Horse").dependent(:destroy) }
    it { is_expected.to have_one(:lease_offer).class_name("Horses::LeaseOffer").dependent(:delete) }
    it { is_expected.to have_one(:current_lease).class_name("Horses::Lease").dependent(:destroy) }
    it { is_expected.to have_one(:leaser).through(:current_lease).source(:leaser) }
    it { is_expected.to have_many(:past_leases).class_name("Horses::Lease").dependent(:destroy) }
    it { is_expected.to have_one(:race_options).class_name("Racing::RaceOption").dependent(:delete) }
    it { is_expected.to have_one(:racehorse_metadata).class_name("Racing::RacehorseMetadata").dependent(:delete) }
    it { is_expected.to have_many(:race_result_finishes).class_name("Racing::RaceResultHorse").dependent(:destroy) }
    it { is_expected.to have_many(:race_results).class_name("Racing::RaceResult").through(:race_result_finishes) }
    it { is_expected.to have_one(:sale_offer).class_name("Horses::SaleOffer").dependent(:delete) }
    it { is_expected.to have_many(:sales).class_name("Horses::Sale").dependent(:delete_all) }
    it { is_expected.to have_one(:current_boarding).class_name("Horses::Racehorse::Boarding").dependent(:delete) }
    it { is_expected.to have_many(:boardings).class_name("Horses::Racehorse::Boarding").dependent(:delete_all) }
    it { is_expected.to have_many(:race_records).class_name("Racing::RaceRecord").inverse_of(:horse) }
    it { is_expected.to have_many(:annual_race_records).class_name("Racing::AnnualRaceRecord").inverse_of(:horse) }
    it { is_expected.to have_one(:lifetime_race_record).class_name("Racing::LifetimeRaceRecord").inverse_of(:horse) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date_of_birth) }

    describe "name" do
      it "can be blank for a new horse" do
        horse = build(:horse, name: nil)
        expect(horse).to be_valid
      end

      it "cannot be blank for a horse who already has a name" do
        horse = create(:horse, name: "Bob")
        horse.name = nil

        expect(horse).not_to be_valid
        expect(horse.errors[:name]).to eq(["can't be blank"])
      end

      it "can be blank for an unnamed horse whose name is not being edited" do
        horse = create(:racehorse, name: nil, gender: "colt")
        horse.gender = "gelding"

        expect(horse).to be_valid
      end

      it "is valid for a horse whose name is not being edited" do
        horse = create(:foal, :yearling, name: "Bob")
        horse.name = "Bob2"

        expect(horse).to be_valid
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns correct fields" do
      expect(described_class.ransackable_attributes).to match_array(
                                                          %w[id age breeder_id dam_id date_of_birth date_of_death foals_count gender location_bred_id name owner_id sire_id state type unborn_foals_count]
                                                        )
    end
  end

  describe ".ransackable_associations" do
    it "returns correct list" do
      expect(described_class.ransackable_associations).to match_array(
                                                            %w[breeder dam location_bred owner sire race_stats racehorse_metadata race_options latest_injury latest_race_result race_qualification race_results next_foal]
                                                          )
    end
  end

  describe "#budget_name" do
    context "when horse name is blank" do
      context "when horse has sire" do
        it "returns unnamed + sire name" do
          horse = create(:horse, :with_sire, name: nil)

          expect(horse.budget_name).to eq "Unnamed (#{horse.sire.name} x Created)"
        end
      end

      context "when horse has dam" do
        it "returns unnamed + dam name" do
          horse = create(:horse, :with_dam, name: nil)

          expect(horse.budget_name).to eq "Unnamed (Created x #{horse.dam.name})"
        end
      end

      context "when horse has sire + dam" do
        it "returns unnamed + sire/dam names" do
          horse = create(:horse, :with_sire, :with_dam, name: nil)

          expect(horse.budget_name).to eq "Unnamed (#{horse.sire.name} x #{horse.dam.name})"
        end
      end
    end

    context "when horse name is not blank" do
      it "returns horse name" do
        horse = create(:horse, sire: nil, dam: nil)

        expect(horse.budget_name).to eq horse.name
      end
    end
  end

  describe "#created?" do
    context "when horse has no sire or dam" do
      it "returns true" do
        horse = build(:horse, sire: nil, dam: nil)
        expect(horse.created?).to be true
      end
    end

    context "when horse has in-game sire" do
      it "returns false" do
        horse = create(:horse, :with_sire, dam: nil)
        expect(horse.created?).to be false
      end
    end

    context "when horse has in-game dam" do
      it "returns false" do
        horse = create(:horse, :with_dam, sire: nil)
        expect(horse.created?).to be false
      end
    end
  end

  describe "#female?" do
    context "when gender is filly" do
      it "returns true" do
        horse = build(:horse, gender: "filly")
        expect(horse.female?).to be true
      end
    end

    context "when gender is mare" do
      it "returns true" do
        horse = build(:horse, gender: "mare")
        expect(horse.female?).to be true
      end
    end

    context "when gender is not filly or mare" do
      it "returns false" do
        horse = build(:horse)
        %w[colt stallion gelding].each do |gender|
          horse.gender = gender
          expect(horse.female?).to be false
        end
      end
    end
  end

  describe "#male?" do
    context "when gender is colt" do
      it "returns true" do
        horse = build(:horse, gender: "colt")
        expect(horse.male?).to be true
      end
    end

    context "when gender is stallion" do
      it "returns true" do
        horse = build(:horse, gender: "stallion")
        expect(horse.male?).to be true
      end
    end

    context "when gender is gelding" do
      it "returns true" do
        horse = build(:horse, gender: "gelding")
        expect(horse.male?).to be true
      end
    end

    context "when gender is not colt, stallion, or gelding" do
      it "returns false" do
        horse = build(:horse)
        %w[filly mare].each do |gender|
          horse.gender = gender
          expect(horse.male?).to be false
        end
      end
    end
  end

  describe "#location_bred_name" do
    context "when location has state" do
      it "returns state/country" do
        location = create(:location, state: "Foo", county: "Bar", country: "US")
        horse = build_stubbed(:horse, location_bred: location)
        expect(horse.location_bred_name).to eq "Foo, US"
      end
    end

    context "when location has county" do
      it "returns county/country" do
        location = create(:location, state: nil, county: "Bar", country: "US")
        horse = build_stubbed(:horse, location_bred: location)
        expect(horse.location_bred_name).to eq "Bar, US"
      end
    end
  end

  describe "#year_of_birth" do
    context "when date of birth is set" do
      it "returns year from date of birth" do
        horse = described_class.new(date_of_birth: 1.year.ago)
        expect(horse.year_of_birth).to eq Date.current.year - 1
      end
    end

    context "when date of birth is blank" do
      it "returns year from date of birth" do
        horse = described_class.new(date_of_birth: nil)
        expect(horse.year_of_birth).to be_nil
      end
    end
  end

  describe "#name_and_foal_status" do
    context "when horse has a name" do
      it "uses the name" do
        horse = described_class.new(name: SecureRandom.alphanumeric(20))
        expect(horse.name_and_foal_status).to eq horse.name
      end
    end

    context "when horse has no dam" do
      context "when multiple created horses have the same date of birth" do
        it "uses the index of each horse based on id" do
          date_of_birth = 3.years.ago.to_date
          horse1 = build(:horse, date_of_birth:, name: nil, sire: nil, dam: nil)
          expect(horse1.name_and_foal_status).to eq "created-#{date_of_birth}"
          horse1.save
          horse2 = build(:horse, date_of_birth:, name: nil, sire: nil, dam: nil)
          expect(horse2.name_and_foal_status).to eq "created-#{date_of_birth}-2"
          horse2.save
          horse3 = build(:horse, date_of_birth:, name: nil, sire: nil, dam: nil)
          expect(horse3.name_and_foal_status).to eq "created-#{date_of_birth}-3"
        end
      end

      context "when it is the only horse with the date of birth" do
        it "uses the date of birth" do
          date_of_birth = 3.years.ago.to_date
          horse = create(:horse, date_of_birth:, name: nil, sire: nil, dam: nil)
          expect(horse.name_and_foal_status).to eq "created-#{date_of_birth}"
        end
      end
    end

    context "when horse has a dam" do
      context "when horse is stillborn" do
        it "uses stillborn and year of birth" do
          horse = create(:foal, :stillborn, :with_dam, name: nil, date_of_birth: Date.current)
          expect(horse.name_and_foal_status).to eq "stillborn-#{Date.current.year}-#{horse.dam.name}"
        end
      end

      context "when horse has a twin" do
        it "uses the order of the twins" do
          dam = create(:broodmare)
          horse = build(:foal, name: nil, date_of_birth: Date.current, dam:)
          expect(horse.name_and_foal_status).to eq "foal-#{Date.current.year}-#{dam.name}"
          horse.save

          horse2 = build(:foal, name: nil, date_of_birth: Date.current, dam:)
          expect(horse2.name_and_foal_status).to eq "foal-#{Date.current.year}-#{dam.name}-2"
        end
      end

      context "when horse has no twin" do
        it "uses foal and year of birth" do
          dam = create(:broodmare)
          horse = build(:foal, name: nil, date_of_birth: Date.current, dam:)
          expect(horse.name_and_foal_status).to eq "foal-#{Date.current.year}-#{dam.name}"
        end
      end
    end
  end
end

