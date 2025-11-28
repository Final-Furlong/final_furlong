module RaceTypeable
  extend ActiveSupport::Concern

  included do
    def claiming?
      race_type.to_s.casecmp("claiming").zero?
    end

    def race_type_string
      value = race_type.titleize.gsub("Nw1 ", "NW1 ").gsub("Nw2 ", "NW2 ").gsub("Nw3 ", "NW3 ")
      value += " (#{grade})" if race_type.downcase == "stakes"
      value
    end

    def race_age_string
      strings = age.chars
      (strings.count > 1) ? strings.join("yo") : "#{strings[0]}yo"
    end

    def race_gender_string
      return "" if !female_only && !male_only?

      string = female_only? ? "F" : "C"
      if age.end_with?("+")
        string += female_only? ? "/M" : "/S/G"
      end
      string
    end

    def equipment_string(object = self)
      values = []
      values << "B" if object.blinkers
      values << "SR" if object.shadow_roll
      values << "W" if object.wraps
      values << "F8" if object.figure_8
      values << "NW" if object.no_whip
      values.join(" ")
    end
  end
end

