module Ui
  module EquipmentForm
    class Component < ApplicationComponent
      attr_reader :label, :blinkers, :shadow_roll, :wraps, :figure_8,
        :no_whip, :disabled, :extra_classes, :id, :object

      def initialize(label: nil, blinkers: false, shadow_roll: false, wraps: false,
        figure_8: false, no_whip: false, disabled: false, classes: "", id:
                       nil, object: nil)
        @label = label
        @blinkers = blinkers
        @shadow_roll = shadow_roll
        @wraps = wraps
        @figure_8 = figure_8
        @no_whip = no_whip
        @disabled = disabled
        @extra_classes = classes
        @id = id
        @object = object
      end

      def before_render
        @label ||= I18n.t("view_components.equipment.form.label")
      end

      def classes
        regular_classes = "fieldset bg-base-100 border-base-300 rounded-box border p-4"
        [regular_classes, extra_classes].compact.join(" ")
      end

      def equipment_list
        %w[blinkers shadow_roll wraps figure_8 no_whip].map do |equipment|
          [equipment, I18n.t("view_components.equipment.form.#{equipment}")]
        end
      end
    end
  end
end

