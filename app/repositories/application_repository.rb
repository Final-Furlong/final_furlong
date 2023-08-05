class ApplicationRepository
  attr_reader :model, :scope

  def initialize(model:, scope: nil)
    @model = model
    @scope = scope || model.all
  end

  class RecordNotFoundError < StandardError; end

  delegate :all, to: :scope

  delegate :first, to: :scope

  delegate :last, to: :scope

  def find(id)
    scope.find(id)
  rescue ActiveRecord::RecordNotFound => e
    raise RecordNotFoundError, e
  end

  def create(attributes)
    entity.create(**attributues)
  end

  def update(id:, attributes:)
    find(id).update(**attributes)
  end

  def destroy(id)
    find(id).destroy
  end

  private

  def entity
    raise NotImplementedError
  end
end

