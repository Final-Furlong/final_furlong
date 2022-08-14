module Horses
  class SearchFiltersComponent < VariantComponent
    include Ransack::Helpers::FormHelper

    attr_reader :query, :params, :path_name

    def initialize(version:, query: nil, params: {}, path_name: nil)
      @path_name = path_name
      @query = query
      @params = params
      super(version:, variants: [:desktop])
    end
  end
end

