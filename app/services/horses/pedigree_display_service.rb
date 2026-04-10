module Horses
  class PedigreeDisplayService
    include ActionView::Helpers::UrlHelper

    attr_reader :horse, :routes

    def initialize(horse)
      @horse = horse
      @routes = Rails.application.routes.url_helpers
    end

    def sire_display(tag: false, target: nil, include_title: false)
      if horse.sire.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.sire, include_title:)
        end
      else
        display_created(tag)
      end
    end

    def name(horse:, include_title: false)
      return I18n.t("horse.created") if horse&.name.blank?

      name_elements = []
      name_elements << horse.title_abbreviation if include_title
      name_elements << horse.name
      name_elements.compact_blank.join(" ")
    end

    def sire_sire_display(tag: false, target: nil, include_title: false)
      if horse.sire&.sire.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.sire.sire, include_title:)
        end
      else
        display_created(tag)
      end
    end

    def sire_dam_display(tag: false, target: nil, include_title: false)
      if horse.sire&.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.sire.dam, include_title:)
        end
      else
        display_created(tag)
      end
    end

    def dam_display(tag: false, target: nil, include_title: false)
      if horse.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.dam, include_title:)
        end
      else
        display_created(tag)
      end
    end

    def dam_sire_display(tag: false, target: nil, include_title: false)
      if horse.dam&.sire.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.dam.sire, include_title:)
        end
      else
        display_created(tag)
      end
    end

    def dam_dam_display(tag: false, target: nil, include_title: false)
      if horse.dam&.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          name(horse: horse.dam.dam, include_title:)
        end
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

