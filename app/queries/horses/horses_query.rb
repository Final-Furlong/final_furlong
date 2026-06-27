module Horses
  class HorsesQuery
    module Scopes
      def name_matches(name)
        return none if name.blank?

        formatted_name = name.downcase.tr(" ", "").tr(".", "").tr("-", "").tr("&", "").tr("'", "")
        where("LOWER(REGEXP_REPLACE(name, '[^a-zA-Z0-9]+','', 'g')) = ?", formatted_name)
      end
    end

    def query
      @query ||= Horse.extending(Scopes)
    end

    def name_matches(filters)
      query.name_matches(filters[:name])
    end
  end
end

