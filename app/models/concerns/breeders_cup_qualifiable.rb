module BreedersCupQualifiable
  extend ActiveSupport::Concern

  included do
    self.primary_key = :horse_id

    scope :ordered, -> { order(stakes_wins: :desc, stakes_seconds: :desc, stakes_thirds: :desc, allowance_wins: :desc, points: :desc, starts: :asc) }
    scope :better_ranked, ->(record) {
      where("stakes_wins > :sw OR (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) > :sp) OR
        (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) = :sp AND allowance_wins > :aw) OR
        (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) = :sp AND allowance_wins = :aw AND points > :pts) OR
        (stakes_wins = :sw AND (stakes_seconds + stakes_thirds) = :sp AND allowance_wins = :aw AND points = :pts AND starts < :st)",
        { sw: record.stakes_wins, sp: record.stakes_seconds + record.stakes_thirds,
          aw: record.allowance_wins, pts: record.points, st: record.starts })
    }
    scope :identically_ranked, ->(record) {
      where(stakes_wins: record.stakes_wins, allowance_wins: record.allowance_wins, points: record.points, starts: record.starts)
        .where("(stakes_seconds + stakes_thirds) = ?", record.stakes_seconds + record.stakes_thirds)
    }
    scope :nominated, -> { where(nominated: true) }
    scope :not_nominated, -> { nominated.invert_where }
    scope :random_order, -> { order("RANDOM()") }

    def readonly?
      true
    end
  end
end

