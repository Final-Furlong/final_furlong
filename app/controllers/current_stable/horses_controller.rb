module CurrentStable
  class HorsesController < AuthenticatedController
    include NonNumericIdOnly

    before_action :set_status_counts, only: :index

    def index
      set_status_counts
      set_active_status
      set_gender_select
      @query = policy_scope(Horses::Horse, policy_scope_class: CurrentStable::HorsePolicy::Scope)
      @query = @query.alive unless @active_status == :deceased
      case @active_status
      when :racehorse
        @query = @query.includes(:lifetime_race_record)
      when :broodmare
        @query = @query.includes(:foal_record, next_foal: :stud)
      when :stud
        @query = @query.includes(:foal_record)
      when :yearling, :weanling
        @query = @query.includes(:sire, :dam)
      end
      @query = @query.ransack(params[:q])
      @query.sorts = "name asc" if @query.sorts.blank?

      @pagy, @horses = pagy(:countless, @query.result)
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
      params.expect(horse: [:name, :gender])
    end

    def set_active_status
      if (type_query = params.dig(:q, :type_eq))
        @active_status = type_query.delete("Horses::Horse::").downcase.to_sym
      elsif (state_query = params.dig(:q, :state_eq))
        @active_status = state_query.to_sym
      else
        starting_status
      end
    end

    def starting_status
      @active_status = set_first_status
      params[:q] ||= {}
      if %i[retired deceased].include? set_first_status
        params[:q][:state_eq] = set_first_status
      else
        params[:q][:type_eq] = "Horses::Horse::#{set_first_status.to_s.capitalize}"
        params[:q][:state_eq] = "active"
      end
    end

    def set_first_status
      return :racehorse if @statuses.fetch(:racehorse, 0).positive?

      @statuses.keys.first&.to_sym || :racehorse
    end

    def set_gender_select
      params[:q][:gender_in] = params[:q][:gender_in].split(",") if params.dig(:q, :gender_in)
    end

    def set_status_counts
      params.to_unsafe_hash["q"].symbolize_keys if params[:q]
      @statuses = Horses::SearchStatusCount.run(query: { owner_name_i_cont_all: Current.stable.name }).result
    end
  end
end

