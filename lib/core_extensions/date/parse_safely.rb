module CoreExtensions
  module Date
    module ParseSafely
      def self.prepended(base)
        base.singleton_class.prepend(ClassMethods)
      end

      module ClassMethods
        def parse_safely(value)
          parse(value&.to_s)
        rescue StandardError
          nil
        end
      end
    end
  end
end
