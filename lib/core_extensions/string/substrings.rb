module CoreExtensions
  module String
    module Substrings
      def substrings(min_length = 1)
        ((min_length - 1)...length).each do |i|
          yield(self[0..i])
        end
      end
    end
  end
end
