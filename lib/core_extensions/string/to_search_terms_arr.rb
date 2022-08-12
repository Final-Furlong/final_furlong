module CoreExtensions
  module String
    module ToSearchTermsArr
      def to_search_terms_arr(&block)
        clean_query = gsub(/[,:;]/, " ").gsub(/%/, '\%')
        terms_array = clean_query.split(/\s+/)
        if block
          terms_array = terms_array.filter_map do |term|
            yield(term) ? nil : term
          end
        end

        terms_array.map { |term| "%#{term}%".downcase }
      end
    end
  end
end

