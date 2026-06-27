class HorsesController < ApplicationController
  include NonNumericIdOnly

  skip_before_action :validate_non_numeric_id, only: :image
  before_action :set_horse, except: %i[index image]
  before_action :set_horse_by_legacy_id, only: :image
  before_action :authorize_horse, except: %i[index gelding geld]
  before_action :set_status_counts, only: :index

  attr_accessor :horses, :horse, :statuses, :active_status, :query

  helper_method :horses, :horse, :statuses, :active_status, :query, :params

  def index # rubocop:disable Metrics/AbcSize
    authorize Horses::Horse

    set_active_status
    set_gender_select
    @query = policy_scope(Horses::Horse).includes(:owner).ransack(params[:q])
    query.sorts = "name asc" if query.sorts.blank?

    @pagy, @horses = pagy(query.result)
  end

  def show
  end

  def edit
  end

  def edit_name
  end

  def update
    result = Horses::NameUpdater.new.change_name(horse: @horse, params: horse_params)
    @horse.reload
    if result.updated?
      redirect_to horse_path(@horse), success: t(".success", name: @horse.name)
    else
      respond_to do |format|
        format.html { render :edit_name, status: :unprocessable_entity }

        format.turbo_stream do
          render turbo_stream: turbo_stream.update("horse_name", partial: "horses/edit_name_form", locals: { horse: @horse })
        end
      end
    end
  end

  def gelding
    @horse = Horses::Horse.find(params[:id])
    authorize @horse, :geld?, policy_class: CurrentStable::HorsePolicy
  end

  def geld
    @horse = Horses::Horse.find(params[:id])
    authorize @horse, :geld?, policy_class: CurrentStable::HorsePolicy
    result = Horses::Gelder.new.geld(horse: @horse)
    @horse.reload
    if result.updated?
      flash[:success] = t(".success", name: @horse.name)
    else
      flash[:error] = result.error
    end
    redirect_to horse_path(@horse)
  end

  def image
    raise ActiveRecord::RecordNotFound unless @horse.appearance&.image&.present?
    image = @horse.appearance.image

    send_image(image)
  ensure
    response.stream.close
  end

  def thumbnail
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

  def authorize_horse
    authorize @horse
  end

  def set_horse
    @horse = Horses::Horse.find(params[:id])
  end

  def set_horse_by_legacy_id
    @horse = Horses::Horse.find_by(legacy_id: params[:id])
  end

  def horse_params
    params.expect(horse: [:name, :gender])
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

