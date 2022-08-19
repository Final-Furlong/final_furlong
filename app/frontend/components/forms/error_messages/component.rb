module Forms
  module ErrorMessages
    class Component < ApplicationViewComponent
      attr_reader :object

      def initialize(object:)
        super()
        @object = object
      end

      private

        def render?
          object.errors.any?
        end
    end
  end
end

