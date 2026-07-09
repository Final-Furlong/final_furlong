module Racing
  class RacehorsesController < AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      raise ActiveRecord::RecordNotFound if params.dig(:q, :race).blank?

      @race = Racing::RaceSchedule.includes(track_surface: :racetrack).find(params.dig(:q, :race))
      @dashboard = Dashboard::Racing::Entry.new(race: @race, params:, user: Current.user)

      @pagy, @horses = pagy(:countless, @dashboard.query.result)
    end
  end
end

