module Horses
  class Gelder
    def geld(horse:)
      result = Result.new(horse:)
      attrs = { gender: "gelding" }
      if horse.stud?
        attrs[:status] = "retired_stud"
      end
      ActiveRecord::Base.transaction do
        if horse.stud?
          horse.stud_options&.destroy
        end
        Horse::Event.create!(horse:, event_type: "gelded", date: Date.current)
        if horse.update(attrs)
          result.updated = true
        else
          result.updated = false
          result.error = horse.errors.full_messages.to_sentence
        end
        result.horse = horse
      end
      result
    end

    class Result
      attr_accessor :error, :updated, :horse

      def initialize(horse:, updated: false, error: nil)
        @updated = updated
        @horse = horse
        @error = nil
      end

      def updated?
        @updated
      end
    end
  end
end

