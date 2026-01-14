module Equipmentable
  extend ActiveSupport::Concern

  included do
    include FlagShihTzu

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "equipment"

    def equipment_string
      return if selected_equipment.empty?

      selected_equipment.map { |equipment| I18n.t("horse.equipment.#{equipment}") }
    end
  end
end

