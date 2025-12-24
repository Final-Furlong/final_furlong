module Nav
  module Breadcrumbs
    class Component < ApplicationComponent
      attr_reader :badge

      def initialize(links: [], mobile_links: [], title: nil, classes: "", badge: nil)
        @title = title
        @links = links
        @mobile_links = mobile_links
        @classes = classes
        @badge = badge
        super()
      end

      private

      def responsive_classes(action)
        "#{action[:base_classes]} #{action[:responsive_classes]}"
      end

      def regular_classes(action)
        "#{action[:base_classes]} #{action[:classes]}"
      end

      def action_i18n_key(action)
        action[:i18n_key]
      end

      def allowed_action?(action)
        return false unless action[:object]

        Pundit.policy!(Current.user, action[:object]).send("#{action[:name]}?")
      end

      def styled_links
        @styled_links ||= @links.map do |link|
          link[:classes] = @classes
          if link == @links.last || link[:title]
            last_link_metadata(link)
          else
            link_metadata(link)
          end
        end
      end

      def styled_mobile_links
        @styled_mobile_links ||= @mobile_links.map do |link|
          link[:classes] = @classes
          if link == @links.last || link[:title]
            last_link_metadata(link)
          else
            link_metadata(link)
          end
        end
      end

      def link_metadata(link)
        link[:breadcrumb_class] = "breadcrumb-item d-none d-md-inline"
        link[:aria_current] = false
        link[:last] = false
        link
      end

      def last_link_metadata(link)
        link[:breadcrumb_class] = "breadcrumb-item active"
        link[:aria_current] = "page"
        link[:last] = true
        link
      end
    end
  end
end

