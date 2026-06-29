module Horses::Horse::Typeable
  extend ActiveSupport::Concern

  included do
    scope :racehorse, -> { where(type: "Horses::Horse::Racehorse") }
    scope :broodmare, -> { where(type: "Horses::Horse::Broodmare") }
    scope :stud, -> { where(type: "Horses::Horse::Stud") }
    scope :foal, -> { where(type: "Horses::Horse::Foal") }
    scope :yearling, -> { foal.with_age(1) }
    scope :weanling, -> { foal.with_age(0) }
    scope :dead, -> { where(state: "deceased") }

    def type_string
      case type
      when "Horses::Horse::Foal"
        (age == 1) ? "yearling" : "weanling"
      else
        type.sub("Horses::Horse::", "").downcase
      end
    end

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

