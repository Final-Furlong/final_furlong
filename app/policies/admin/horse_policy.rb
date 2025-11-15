module Admin
  class HorsePolicy < ApplicationPolicy
    def change_owner?
      false # TODO: implement owner change

      # admin?
    end
  end
end

