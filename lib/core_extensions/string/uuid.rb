module CoreExtensions
  module String
    module UUID
      def uuid?
        match?(/^\h{8}-(\h{4}-){3}\h{12}$/)
      end
    end
  end
end

