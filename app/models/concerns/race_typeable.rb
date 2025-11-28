module RaceTypeable
  extend ActiveSupport::Concern

  included do
    def claiming?
      race_type.to_s.casecmp("claiming").zero?
    end

    def race_surface_type
      (track_surface.surface == "steeplechase") ? "jump" : "flat"
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

    def race_description_string
      race_description = I18n.t("racing.results.race_number", number:) +
        ", " + I18n.t("racing.race.furlongs", number: distance) + " "
      race_description += " " + track_surface.surface.titleize + " "
      race_description += if claiming?
        price = Game::MoneyFormatter.new(claiming_price).to_s
        I18n.t("racing.race.claiming_with_price", price:)
      else
        I18n.t("racing.race.#{race_type.downcase}")
      end
      race_description += " " + I18n.t("racing.race.age_desc", age: race_age_string)
      if race_gender_string.present?
        race_description += " " + race_gender_string
      end
      race_description + ", " + Game::MoneyFormatter.new(purse).to_s
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

