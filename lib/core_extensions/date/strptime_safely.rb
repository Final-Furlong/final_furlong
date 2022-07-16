module CoreExtensions
  module Date
    module StrptimeSafely
      def self.prepended(base)
        base.singleton_class.prepend(ClassMethods)
      end

      module ClassMethods
        def strptime_safely(value, format)
          strptime(value, format)
        rescue StandardError
          nil
        end
      end
    end
  end
end
