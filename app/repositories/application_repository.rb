class ApplicationRepository
  attr_reader :model, :scope

  def initialize(model:, scope: nil)
    @model = model
    @scope = scope || model.all
  end

  delegate :all, to: :scope

  delegate :first, to: :scope

  delegate :last, to: :scope

  delegate :find, to: :scope

  def find_by!(args)
    model.find_by!(**args)
  end

  def create(attributes)
    model.create(**attributes)
  end

  def create!(attributes)
    model.create!(**attributes)
  end

  def update(id:, attributes:)
    find(id).update(**attributes)
  end

  def update!(id:, attributes:)
    find(id).update!(**attributes)
  end

  def destroy(id)
    find(id).destroy
  end
end

