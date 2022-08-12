class HorsesQuery
  module Scopes
    def name_matches(name)
      return self if name.blank?

      formatted_name = name.downcase.tr(" ", "").tr(".", "").tr("\-", "").tr("&", "")
      where("LOWER(TRANSLATE(\"name\", ' .-&''', '')) = ?", formatted_name)
    end
  end

  def self.call(filters)
    Horse
      .extending(Scopes)
      .name_matches(filters[:name])
  end
end

