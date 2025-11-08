module CurrentStable
  class HorsesController < AuthenticatedController
    include NonNumericIdOnly

    before_action :set_status_counts, only: :index

    def index
      @query = policy_scope(Horses::Horse, policy_scope_class: CurrentStable::HorsePolicy::Scope).includes(:owner).ransack(params[:q])
      @query.sorts = "name asc" if @query.sorts.blank?

      @pagy, @horses = pagy(@query.result)
    end

    def show
      @horse = Current.stable.horses.find(params[:id])
      authorize @horse, policy_class: CurrentStable::HorsePolicy
    end

    def edit
      @horse = Current.stable.horses.find(params[:id])
    end

    def update
      if @horse.update(horse_params)
        redirect_to stable_horses_path, notice: t(".success", name: @horse.name)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def horse_params
      params.expect(horse: [:name])
    end

    def set_active_status
      if params.dig(:q, :status_in)
        @active_status = :retired
      elsif params.dig(:q, :status_eq)
        @active_status = params.dig(:q, :status_eq).to_sym
      else
        starting_status
      end
    end

    def starting_status
      @active_status = set_first_status
      params[:q] ||= {}
      if set_first_status == :retired
        params[:q][:status_in] = %i[retired retired_stud retired_broodmare]
      else
        params[:q][:status_eq] = set_first_status
      end
    end

    def set_first_status
      return :racehorse if statuses.fetch(:racehorse, 0).positive?

      statuses.keys.first&.to_sym || :racehorse
    end

    def set_gender_select
      params[:q][:gender_in] = params[:q][:gender_in].split(",") if params.dig(:q, :gender_in)
    end

    def set_status_counts
      query = params.to_unsafe_hash["q"].symbolize_keys if params[:q]
      @statuses = Horses::SearchStatusCount.run(query:).result
    end
  end
end

