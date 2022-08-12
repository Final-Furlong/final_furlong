class ApplicationRepository
  attr_reader :model, :scope

  def initialize(model:, scope: nil)
    @model = model
    @scope = scope || model.all
  end
end

