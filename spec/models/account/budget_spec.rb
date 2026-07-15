describe Account::Budget do
  describe "scopes" do
    describe ".budget_category" do
      it "returns sold or bought" do
        matching_budgets = []
        Config::Budgets.sales_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "entered_race")

        result = described_class.budget_category("sold_or_bought")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns breeding" do
        matching_budgets = []
        Config::Budgets.breeding_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "entered_race")

        result = described_class.budget_category("all_breeding")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns racing" do
        matching_budgets = []
        Config::Budgets.racing_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "sold_horse")

        result = described_class.budget_category("all_racing")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns nominations" do
        matching_budgets = []
        Config::Budgets.nominating_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "sold_horse")

        result = described_class.budget_category("all_nominations")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns game activity" do
        matching_budgets = []
        Config::Budgets.game_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "sold_horse")

        result = described_class.budget_category("game_activity")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns misc" do
        matching_budgets = []
        Config::Budgets.misc_activities.each do |activity|
          matching_budgets << create(:budget, activity_type: activity)
        end
        non_matching_budget = create(:budget, activity_type: "sold_horse")

        result = described_class.budget_category("misc")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budget
      end

      it "returns other" do
        matching_budget = create(:budget, activity_type: "paid_tax")
        non_matching_budget = create(:budget, activity_type: "sold_horse")

        result = described_class.budget_category("paid_tax")
        expect(result).to include matching_budget
        expect(result).not_to include non_matching_budget
      end
    end

    describe ".budget_description" do
      it "handles values in quotes" do
        matching_budget = create(:budget, description: "Johnny won a race")
        non_matching_budget = create(:budget, description: "Mary won a race")

        result = described_class.budget_description('"Johnny won"')
        expect(result).to include matching_budget
        expect(result).not_to include non_matching_budget
      end

      it "handles values not in quotes" do
        matching_budgets = [
          create(:budget, description: "Johnny won a race"),
          create(:budget, description: "Johnny bred a mare"),
          create(:budget, description: "Bob won a race")
        ]
        non_matching_budgets = [
          create(:budget, description: "Bob bred a mare"),
          create(:budget, description: "Mary bred to Steve")
        ]

        result = described_class.budget_description("Johnny won")
        expect(result).to match_array matching_budgets
        expect(result).not_to include non_matching_budgets
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns the right values" do
      expect(described_class.ransackable_attributes).to match_array(
        %w[activity_type amount balance description created_at updated_at]
      )
    end
  end

  describe ".ransackable_associations" do
    it "returns the right values" do
      expect(described_class.ransackable_associations).to be_empty
    end
  end

  describe ".ransackable_scopes" do
    it "returns the right values" do
      expect(described_class.ransackable_scopes).to match_array(
        %w[budget_category budget_description]
      )
    end
  end
end

