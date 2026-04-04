module Racing
  class RacehorsesController < AuthenticatedController
    def index
      base_query = Horses::Horse.racehorse.includes(:race_options, race_metadata: :racetrack).where.missing(:race_entries)
      @query = policy_scope(base_query, policy_scope_class: CurrentStable::RacehorsePolicy::Scope)
      @race = Racing::RaceSchedule.find(params.dig(:q, :race)) if params.dig(:q, :race).present?
      @query = RaceQualificationQuery.new(race: @race, status:).qualified(apply_settings: false)
      @query = @query.ransack(params[:q])
      @query.sorts = ["name asc"] if @query.sorts.empty?
      @query.sorts.insert 0, Ransack::Nodes::Sort.extract(@query.context, "race_options_racehorse_type desc")

      @pagy, @horses = pagy(:offset, @query.result)
      page = status ? status.to_sym : :index
      render page
    end

    private

    def status
      return @status if defined?(@status)

      chosen_status = params[:q]&.dig(:racehorse_status)&.downcase
      return unless chosen_status
      return unless Config::Racing.all_types.include?(chosen_status)

      @status = chosen_status
    end

    def race_type
      return @race_type if defined?(@race_type)

      chosen_type = params[:q]&.delete(:surface)&.downcase
      return unless chosen_type
      return unless Config::Racing.racehorse_types.include?(chosen_type)

      @race_type = chosen_type
    end
  end
end

