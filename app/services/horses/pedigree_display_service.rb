module Horses
  class PedigreeDisplayService
    include ActionView::Helpers::UrlHelper

    attr_reader :horse, :routes

    def initialize(horse)
      @horse = horse
      @routes = Rails.application.routes.url_helpers
    end

    def sire_display
      if horse.sire.present?
        link_to horse.sire.name, routes.horse_path(horse.sire)
      else
        I18n.t("horse.created")
      end
    end

    def sire_sire_display
      if horse.sire&.sire.present?
        link_to horse.sire.sire.name, routes.horse_path(horse.sire.sire)
      else
        I18n.t("horse.created")
      end
    end

    def sire_dam_display
      if horse.sire&.dam.present?
        link_to horse.sire.dam.name, routes.horse_path(horse.sire.dam)
      else
        I18n.t("horse.created")
      end
    end

    def dam_display
      if horse.dam.present?
        link_to horse.dam.name, routes.horse_path(horse.dam)
      else
        I18n.t("horse.created")
      end
    end

    def dam_sire_display
      if horse.dam&.sire.present?
        link_to horse.dam.sire.name, routes.horse_path(horse.dam.sire)
      else
        I18n.t("horse.created")
      end
    end

    def dam_dam_display
      if horse.dam&.dam.present?
        link_to horse.dam.dam.name, routes.horse_path(horse.dam.dam)
      else
        I18n.t("horse.created")
      end
    end
  end
end

