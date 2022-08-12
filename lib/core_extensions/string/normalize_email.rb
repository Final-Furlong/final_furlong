module CoreExtensions
  module String
    module NormalizeEmail
      def normalize_email
        strip.downcase
      end

      def normalize_email!
        strip!
        downcase!
      end
    end
  end
end

