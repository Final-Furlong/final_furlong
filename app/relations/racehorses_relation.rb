class RacehorsesRelation < BaseRelation
  schema(:raceoorses, infer: true)

  def all
    select(:id, :acceleration).order(:id)
  end
end

