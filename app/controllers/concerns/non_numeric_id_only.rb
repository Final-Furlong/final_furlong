module NonNumericIdOnly
  extend ActiveSupport::Concern

  included do
    before_action :validate_non_numeric_id
  end

  def validate_non_numeric_id
    # raise ActiveRecord::RecordNotFound if !current_user&.admin? && numeric_param?
    raise ActiveRecord::RecordNotFound if numeric_param?
  end

  def numeric_param?
    return false unless request.method.to_s.downcase == "get"
    return false unless params[:id]

    return true if /\A\d+\Z/.match?(params[:id])
    begin
      true if Float(params[:id])
    rescue
      false
    end
  end
end

