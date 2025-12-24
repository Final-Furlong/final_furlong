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
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.sire.name
        end
      else
        display_created(tag)
      end
    end

    def sire_sire_display(tag: false, target: nil)
      if horse.sire&.sire.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.sire.sire.name
        end
      else
        display_created(tag)
      end
    end

    def sire_dam_display(tag: false, target: nil)
      if horse.sire&.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.sire.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.sire.dam.name
        end
      else
        display_created(tag)
      end
    end

    def dam_display(tag: false, target: nil)
      if horse.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.dam.name
        end
      else
        display_created(tag)
      end
    end

    def dam_sire_display(tag: false, target: nil)
      if horse.dam&.sire.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.sire.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.dam.sire.name
        end
      else
        display_created(tag)
      end
    end

    def dam_dam_display(tag: false, target: nil)
      if horse.dam&.dam.present?
        component = Ui::Link::Component.new(url: routes.horse_path(horse.dam.dam.slug), data: { turbo_frame: target })
        ApplicationController.new.view_context.render(component) do
          horse.dam.dam.name
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

