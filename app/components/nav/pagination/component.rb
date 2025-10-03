module Nav
  module Pagination
    class Component < ApplicationComponent
      attr_reader :collection, :page, :div_class

      def initialize(collection:, page:, div_class:)
        super()
        @collection = collection
        @page = page || 1
        @div_class = div_class
      end

      private

      def render?
        # collection.total_pages > 1
      end
    end
  end
end

