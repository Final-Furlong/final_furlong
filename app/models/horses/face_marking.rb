module Horses
  class FaceMarking
    VALUES = {
      bald_face: "bald_face",
      blaze: "blaze",
      snip: "snip",
      star: "star",
      star_snip: "star_snip",
      star_stripe: "star_stripe",
      star_stripe_snip: "star_stripe_snip",
      stripe: "stripe",
      stripe_snip: "stripe_snip"
    }.freeze

    def initialize(marking)
      @marking = marking.to_s
    end

    def to_s
      @marking.titleize
    end
  end
end

