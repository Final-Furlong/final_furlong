module BreedRankable
  extend ActiveSupport::Concern

  included do
    scope :bronze, -> { where(breed_ranking: "bronze") }
    scope :silver, -> { where(breed_ranking: "silver") }
    scope :gold, -> { where(breed_ranking: "gold") }
    scope :platinum, -> { where(breed_ranking: "platinum") }
    scope :not_gold_or_platinum, -> { where(breed_ranking: [nil, "bronze", "silver"]) }

    def breed_ranking_string
      return I18n.t("common.none") if breed_ranking.blank?

      "#{breed_ranking.titleize} (#{total_foal_points.fdiv(total_foal_races).round(1)})"
    end
  end
end

