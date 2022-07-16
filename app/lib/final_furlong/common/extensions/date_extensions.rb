module FinalFurlong
  module Common
    class Date
      def self.parse_safely(value)
        Date.parse(value&.to_s)
      rescue StandardError
        nil
      end

      def self.strptime_safely(value, format)
        Date.strptime(value, format)
      rescue StandardError
        nil
      end
    end
  end
end
