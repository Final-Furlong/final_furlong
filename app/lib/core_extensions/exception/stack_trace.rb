module CoreExtensions
  module Exception
    module StackTrace
      def stack_trace
        backtrace&.join("\n\t")
      end
    end
  end
end

