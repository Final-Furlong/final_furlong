module Nav
  module Breadcrumbs
    class Component < ApplicationViewComponent
      attr_reader :actions

      def initialize(links: [], title: nil, classes: "", actions: [])
        @title = title
        @links = links
        @classes = classes
        @actions = actions
        super
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
        return false unless action[:user] && action[:object]

        ActionPolicy.lookup(action[:object]).new(action[:object], user: action[:user]).apply("#{action[:name]}?".to_sym)
      end

      def styled_links
        @styled_links ||= @links.map do |link|
          link[:classes] = @classes
          if link == @links.last
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

