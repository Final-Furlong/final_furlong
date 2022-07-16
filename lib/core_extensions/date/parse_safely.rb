module CoreExtensions
  module Date
    module ParseSafely
      def self.included(base)
        base.instance_eval do
          def parse_safely(value)
            parse(value&.to_s)
          rescue StandardError
            nil
          end
        end
      end
    end
  end
end
