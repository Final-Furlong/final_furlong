class Racing::EquipmentStatusGenerator
  attr_reader :current_equipment, :desired_equipment

  HATE = :hate
  DISLIKE = :dislike
  LOVE = :love

  STATUS_MODIFIERS = {
    Racing::EquipmentStatusGenerator::HATE => 0.9,
    Racing::EquipmentStatusGenerator::DISLIKE => 0.95,
    Racing::EquipmentStatusGenerator::LOVE => 1.1
  }.freeze

  def initialize(current_equipment:, desired_equipment:)
    @current_equipment = current_equipment
    @desired_equipment = desired_equipment
  end

  def call
    has_but_does_not_want = current_equipment - desired_equipment
    wants_but_does_not_have = desired_equipment - current_equipment
    if has_but_does_not_want.present?
      HATE
    elsif wants_but_does_not_have.present?
      DISLIKE
    else
      LOVE
    end
  end
end

