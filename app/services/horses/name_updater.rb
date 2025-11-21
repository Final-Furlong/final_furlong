module Horses
  class NameUpdater
    attr_reader :offer

    def change_name(horse:, params:)
      new_name = params[:name]

      result = Result.new(horse:)
      ActiveRecord::Base.transaction do
        if horse.update(name: new_name)
          result.updated = Legacy::Horse.find_by(ID: horse.legacy_id).update(Name: new_name, slug: horse.reload.slug)
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

