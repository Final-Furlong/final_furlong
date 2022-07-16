module FinalFurlong
  module Common
    class Exception
      def stack_trace
        backtrace&.join("\n\t")
      end
    end
  end
end
