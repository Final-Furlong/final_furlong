module CoreExtensions
  module Date
    module StrptimeSafely
      def self.included(base)
        base.instance_eval do
          def strptime_safely(value, format)
            strptime(value, format)
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
