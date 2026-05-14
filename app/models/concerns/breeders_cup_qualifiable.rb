module BreedersCupQualifiable
  extend ActiveSupport::Concern

  included do
    self.primary_key = :horse_id

    scope :ordered, -> { order(stakes_wins: :desc, stakes_seconds: :desc, stakes_thirds: :desc, allowance_wins: :desc, points: :desc) }
    scope :better_ranked, ->(record) {
      where("stakes_wins > :sw OR (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) > :sp) OR
        (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) = :sp AND allowance_wins > :aw) OR
        (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) = :sp AND allowance_wins = :aw AND points > :pts)",
        { sw: record.stakes_wins, sp: record.stakes_seconds + record.stakes_thirds,
          aw: record.allowance_wins, pts: record.points + 1 })
    }
    scope :identically_ranked, ->(record) {
      where(stakes_wins: record.stakes_wins, allowance_wins: record.allowance_wins, points: record.points)
        .where("(stakes_seconds + stakes_thirds) = ?", record.stakes_seconds + record.stakes_thirds)
    }
    scope :nominated, -> { where(nominated: true) }

    def readonly?
      true
    end
  end
end

