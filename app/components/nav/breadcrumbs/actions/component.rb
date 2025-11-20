module Nav
  module Breadcrumbs
    module Actions
      class Component < ApplicationComponent
        attr_reader :actions, :object, :path

        def initialize(actions: [], path: "", object: nil)
          @actions = actions
          @path = path
          @object = object
          super()
        end

        private

        def first_action
          actions.first
        end

        def regular_classes(action)
          "#{action[:base_classes]} #{action[:classes]}"
        end

        def action_i18n_key(action)
          action[:i18n_key]
        end

        def render_action(action, classes)
          (action[:type] == :form) ? button_action(action, classes) : link_action(action, classes)
        end

        def link_action(action, classes)
          link_to t(action_i18n_key(action)), action[:link], type: "button", class: classes
        end

        def button_action(action, classes)
          button_to t(action_i18n_key(action)), action[:link], type: "button", class: classes, form_class: "d-inline"
        end

        def action_path(action)
          "#{path}#{action}"
        end

        def render?
          actions.any?
        end
      end
    end
  end
end

