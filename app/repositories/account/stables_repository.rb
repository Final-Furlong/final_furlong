module Account
  class StablesRepository < ApplicationRepository
    def initialize(model: Stable, scope: nil)
      @model = model
      super
    end

    def active
      scope.joins(:user).includes(:user).merge(UsersRepository.new.active)
    end

    def ordered_by_name
      model.order(name: :asc)
    end

    def name_includes(string)
      model.where("name ILIKE ?", "%#{string}%")
    end
  end
end

