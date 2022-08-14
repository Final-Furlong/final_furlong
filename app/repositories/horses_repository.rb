class HorsesRepository < ApplicationRepository
  def initialize(model: Horse, scope: nil)
    @model = model
    super
  end

  def born
    scope.not_unborn
  end
end

