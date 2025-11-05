module Horses
  class PedigreeDisplayService
    include ActionView::Helpers::UrlHelper

    attr_reader :horse, :routes

    def initialize(horse)
      @horse = horse
      @routes = Rails.application.routes.url_helpers
    end

    def sire_display(tag: false, target: nil)
      if horse.sire.present?
        link_to(horse.sire.name, routes.horse_path(horse.sire.slug), target:)
      else
        display_created(tag)
      end
    end

    def sire_sire_display(tag: false)
      if horse.sire&.sire.present?
        link_to horse.sire.sire.name, routes.horse_path(horse.sire.sire.slug)
      else
        display_created(tag)
      end
    end

    def sire_dam_display(tag: false)
      if horse.sire&.dam.present?
        link_to horse.sire.dam.name, routes.horse_path(horse.sire.dam.slug)
      else
        display_created(tag)
      end
    end

    def dam_display(tag: false)
      if horse.dam.present?
        link_to horse.dam.name, routes.horse_path(horse.dam.slug)
      else
        display_created(tag)
      end
    end

    def dam_sire_display(tag: false)
      if horse.dam&.sire.present?
        link_to horse.dam.sire.name, routes.horse_path(horse.dam.sire.slug)
      else
        display_created(tag)
      end
    end

    def dam_dam_display(tag: false)
      if horse.dam&.dam.present?
        link_to horse.dam.dam.name, routes.horse_path(horse.dam.dam.slug)
      else
        display_created(tag)
      end
    end

    private

    def display_created(tag)
      if tag
        content_tag(:em, I18n.t("horse.created"))
      else
        I18n.t("horse.created")

      end
    end
  end
end

