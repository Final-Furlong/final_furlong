module Ui
  module Pagination
    class Component < ApplicationComponent
      attr_reader :pagy, :class_name, :slots, :classes

      def initialize(pagy:, class_name: "float-right", mobile: false, classes: "")
        @pagy = pagy
        @class_name = class_name
        @slots = mobile ? 3 : 9
        @classes = classes
      end

      def class_list
        [classes, class_name].compact_blank.join(" ")
      end

      def render?
        data = @pagy.data_hash(data_keys: %i[count limit])
        data[:count] > data[:limit]
      end
    end
  end
end

