module Horse
  class JockeysController < ApplicationController
    def index
      @horse = Horses::Horse.find(params[:id])
      authorize @horse, :view_jockeys?, policy_class: CurrentStable::RacehorsePolicy

      @query = policy_scope(Racing::HorseJockeyRelationship.where(horse: @horse).for_type(@horse.race_options.racehorse_type))
      @query = @query.includes(:horse, :jockey)
      @query = @query.merge(Racing::HorseJockeyRelationship.ordered_by_best)
      @pagy, @relationships = pagy(:offset, @query)
    end
  end
end

