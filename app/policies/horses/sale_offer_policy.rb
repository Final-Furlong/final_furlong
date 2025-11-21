module Horses
  class SaleOfferPolicy < ::AuthenticatedPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.valid_for_stable(stable)
      end
    end
  end
end

