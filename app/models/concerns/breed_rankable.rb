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

      "#{breed_ranking.titleize} (#{breed_ranking_points})"
    end

    def breed_ranking_abbr
      return "" if breed_ranking.blank?

      " (#{breed_ranking[0].titleize})"
    end
  end
end

