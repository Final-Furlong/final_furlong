module Nav
  module Breadcrumbs
    class Component < ApplicationComponent
      attr_reader :actions, :badge

      def initialize(links: [], mobile_links: [], title: nil, classes: "", actions: [], badge: nil)
        @title = title
        @links = links
        @mobile_links = mobile_links
        @classes = classes
        @actions = actions
        @badge = badge
        super()
      end

      private

      def render_action(action, classes)
        (action[:type] == :form) ? button_action(action, classes) : link_action(action, classes)
      end

      def link_action(action, classes)
        link_to t(action_i18n_key(action)), action[:link], type: "button", class: classes
      end

      def button_action(action, classes)
        button_to t(action_i18n_key(action)), action[:link], type: "button", class: classes, form_class: "d-inline"
      end

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

