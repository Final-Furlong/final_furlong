describe Horses::Horse::Typeable do
  describe "#racehorse?" do
    it "returns true for racehorse" do
      expect(Horses::Horse::Racehorse.new.racehorse?).to be true
    end

    it "returns false for stud" do
      expect(Horses::Horse::Stud.new.racehorse?).to be false
    end

    it "returns false for broodmare" do
      expect(Horses::Horse::Broodmare.new.racehorse?).to be false
    end

    it "returns false for foal" do
      expect(Horses::Horse::Foal.new.racehorse?).to be false
    end
  end

  describe "#stillborn?" do
    context "when date of birth == date of death" do
      it "returns true" do
        expect(Horses::Horse::Foal.new(date_of_birth: Date.current, date_of_death: Date.current).stillborn?).to be true
      end
    end

    context "when date of birth != date of death" do
      it "returns false" do
        expect(Horses::Horse::Foal.new(date_of_birth: Date.current - 1.day, date_of_death: Date.current).stillborn?).to be false
      end
    end
  end

  describe "#dead?" do
    context "when state is deceased" do
      it "returns true" do
        expect(Horses::Horse::Foal.new(state: "deceased").dead?).to be true
      end
    end

    context "when state is not deceased" do
      it "returns false" do
        expect(Horses::Horse::Foal.new(state: "retired").dead?).to be false
      end
    end
  end
end

