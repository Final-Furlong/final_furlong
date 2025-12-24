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

        def single_action_classes
          "mr-2 text-green-800 bg-transparent border border-green-800 hover:bg-green-900 hover:text-white focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-xs px-3 py-1.5 text-center dark:hover:bg-green-600 dark:border-green-600 dark:text-green-400 dark:hover:text-white dark:focus:ring-green-800"
        end

        def dropdown_classes
          "block px-4 py-2 w-full text-left text-sm text-gray-300 focus:bg-white/5 focus:text-white focus:outline-hidden"
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

