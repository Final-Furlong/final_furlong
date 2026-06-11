module Racing
  class RacesController < AuthenticatedController
    def index
      query = policy_scope(Racing::RaceSchedule).includes(track_surface: :racetrack)
      date = params[:date].presence || Racing::RaceSchedule.future.minimum(:date)
      query = query.where(date:)
      query = query.order(number: :asc) # TODO: replace with user-picked field(s)

      @races = query.to_a
      raise ActiveRecord::RecordNotFound if @races.blank?
    end

    def all
      @query = policy_scope(Racing::RaceSchedule.future_including_today).includes(track_surface: :racetrack)
      gender = params[:q].delete(:gender) if params[:q]
      @query = case gender
      when "open"
        @query.where(female_only: false, male_only: false)
      when "male"
        @query.where(male_only: true)
      when "female"
        @query.where(female_only: true)
      else
        @query
      end
      @query = @query.ransack(params[:q])
      @query.sorts = ["date asc", "number asc"] if @query.sorts.blank?
      @count = @query.result.count

      @pagy, @races = pagy(:countless, @query.result)
    end

    def show
    end

    def post_parade
      query = policy_scope(Racing::RaceSchedule).includes(entries: [:jockey, horse: [:manager, :sire, :dam]], track_surface: :racetrack)
      @date = params[:date].presence || Racing::RaceSchedule.future.minimum(:date)
      query = query.where(date: @date)
      query = query.order(number: :asc)

      @pagy, @races = pagy(:countless, query, limit: 2)
      authorize @races.first, :post_parade?
    end
  end
end
