module Horses::Horse::Typeable
  extend ActiveSupport::Concern

  included do
    scope :racehorse, -> { where(type: "Horses::Horse::Racehorse") }
    scope :broodmare, -> { where(type: "Horses::Horse::Broodmare") }
    scope :stud, -> { where(type: "Horses::Horse::Stud") }
    scope :foal, -> { where(type: "Horses::Horse::Foal") }

    def racehorse?
      type == "Horses::Horse::Racehorse"
    end

    def foal?
      type == "Horses::Horse::Foal"
    end

    def broodmare?
      type == "Horses::Horse::Broodmare"
    end

    def stud?
      type == "Horses::Horse::Stud"
    end

    def weanling?
      !stillborn? && age == 0
    end

    def yearling?
      !stillborn? && age == 1
    end

    def stillborn?
      self[:date_of_birth] == self[:date_of_death]
    end
  end
end

