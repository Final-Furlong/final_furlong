module Horses
  class LegMarking
    VALUES = {
      coronet: "coronet",
      ermine: "ermine",
      sock: "sock",
      stocking: "stocking"
    }.freeze

    def initialize(marking)
      @marking = marking.to_s
    end

    def to_s
      @marking.titleize
    end
  end
end

