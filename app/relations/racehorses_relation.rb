class RacehorsesRelation < ROM::Relation[:sql]
  gateway :default

  schema(:raceoorses, infer: true)

  def all
    select(:id, :acceleration).order(:id)
  end
end

