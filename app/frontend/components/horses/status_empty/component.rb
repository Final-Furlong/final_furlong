module Horses
  module StatusEmpty
    class Component < VariantComponent
      attr_reader :status

      def initialize(version:, status: nil)
        @status = status
        super(version:)
      end
    end
  end
end

