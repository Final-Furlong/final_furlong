module CoreExtensions
  module DateTime
    module ParseSafely
      def self.included(base)
        base.instance_eval do
          def parse_safely(value)
            parse(value)
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
