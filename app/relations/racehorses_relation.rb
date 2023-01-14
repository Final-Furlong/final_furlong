class RacehorsesRelation < ROM::Relation[:sql]
  gateway :default

  schema(:racehorses, infer: true)

  def all
    select(:id, :acceleration).order(:id)
  end
end

