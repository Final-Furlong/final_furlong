module Horses
  class StatusEmptyComponent < ApplicationComponent
    attr_reader :status

    def initialize(status: nil)
      @status = status
      super
    end

    private

      def render?
        statuses.key?(status)
      end
  end
end

