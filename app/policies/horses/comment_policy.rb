module Horses
  class CommentPolicy < ::ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(stable:).visible_by_owner.or(scope.visible_by_all)
      end
    end

    def new?
      manager?
    end

    def create?
      new?
    end

    def edit?
      manager?
    end

    def update?
      edit?
    end

    def destroy?
      edit?
    end

    private

    def manager?
      record.horse.manager_id == stable&.id
    end
  end
end

