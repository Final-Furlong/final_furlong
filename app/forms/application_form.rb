class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  def initialize
    initial_attributes
  end

  private

  def initial_attributes
    raise NotImplementedError, "must be defined in #{self.class}"
  end
end
