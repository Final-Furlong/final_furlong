class HorsesController < ApplicationController
  attr_accessor :horses, :horse, :statuses, :active_status

  helper_method :horses, :horse, :statuses, :active_status, :params

  def index # rubocop:disable Metrics/AbcSize
    authorize Horses::Horse

    query = params.to_unsafe_hash["q"].symbolize_keys if params[:q]
    @statuses = Horses::SearchStatusCount.run(query:).result

    set_active_status
    set_gender_select
    @query = policy_scope(Horses::Horse).includes(:owner).ransack(params[:q])
    @query.sorts = "name asc" if @query.sorts.blank?

    @pagy, @horses = pagy(@query.result)
  end

  def show
    @horse = load_horse
    authorize @horse
  end

  def edit
    @horse = load_horse
    authorize @horse
  end

  def update
    @horse = load_horse
    authorize @horse
    if @horse.update(horse_params)
      @horse.reload
      respond_to do |format|
        format.html { redirect_to horses_path, notice: t(".success", name: @horse.name) }
        format.turbo_stream { flash.now[:success] = t(".success", name: @horse.name) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def image
    @horse = load_horse_by_legacy_id
    raise ActiveRecord::RecordNotFound unless @horse.appearance&.image&.present?
    image = @horse.appearance.image

    send_image(image)
  ensure
    response.stream.close
  end

  def thumbnail
    @horse = load_horse
    raise ActiveRecord::RecordNotFound unless @horse.appearance&.image(max_width: 100, max_height: 100)&.present?
    image = @horse.appearance.image(max_width: 100, max_height: 100)

    send_image(image)
  ensure
    response.stream.close
  end

  private

  def send_image(image)
    content_type = File.extname(image.path.split("/").last)
    response.headers["Content-Type"] = "image/#{content_type.delete(".")}"
    filename = [@horse.id, content_type].join("")
    response.headers["Content-Disposition"] = "attachment; filename=#{filename}"

    response.stream.write(File.read(image))
  end

  def load_horse
    Horses::Horse.find(params[:id])
  end

  def load_horse_by_legacy_id
    if UUID.validate(params[:id].to_s)
      Horses::Horse.find_by(id: params[:id])
    else
      Horses::Horse.find_by(legacy_id: params[:id])
    end
  end

  def horse_params
    params.expect(horse: [:name, :date_of_birth])
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
end

