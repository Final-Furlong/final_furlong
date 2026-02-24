class Workouts::WorkoutCommentGenerator
  attr_reader :knowledge, :stat, :value, :random_chance, :workout

  def initialize(knowledge:, stat:, value:, workout:)
    @knowledge = knowledge.clamp(10, 90)
    @stat = stat
    @value = value
    @workout = workout
    @random_chance = rand(1...100)
  end

  def call
    comment_i18n_key = case stat.to_s.downcase
    when "equipment"
      equipment_value
    when "stamina"
      stamina_value
    when "energy"
      energy_value
    when "fitness"
      fitness_value
    when "happy"
      happy_value
    when "weight"
      weight_value
    when "style"
      style_value
    when "pissy"
      pissy_value
    when "ratability"
      ratability_value
    when "xp"
      xp_value
    when "confidence"
      confidence_value
    when "natural_energy"
      natural_energy_value
    end
    Racing::WorkoutComment.find_by(comment_i18n_key:)
  end

  def equipment_value
    case value
    when Racing::EquipmentStatusGenerator::HATE
      if correct?
        "equipment_20"
      elsif totally_wrong?
        "equipment_100"
      else
        "equipment_50"
      end
    when Racing::EquipmentStatusGenerator::LOVE
      if correct?
        "equipment_100"
      elsif totally_wrong?
        "equipment_20"
      else
        "equipment_50"
      end
    else
      if correct?
        "equipment_50"
      elsif totally_wrong?
        "equipment_100"
      else
        "equipment_20"
      end
    end
  end

  def stamina_value
    if total_distance > value
      correct? ? "stamina_50" : "stamina_100"
    else
      correct? ? "stamina_100" : "stamina_50"
    end
  end

  def energy_value
    if value < 51
      correct? ? "energy_50" : "energy_100"
    else
      correct? ? "energy_100" : "energy_50"
    end
  end

  def fitness_value
    if value < 61
      correct? ? "fitness_50" : "fitness_100"
    else
      correct? ? "fitness_100" : "fitness_50"
    end
  end

  def happy_value
    if value < 21
      "happy_20"
    elsif value < 41
      "happy_40"
    elsif value < 61
      "happy_60"
    else
      "happy_80"
    end
  end

  def weight_value
    if jockey_weight > value
      "weight_100"
    else
      "weight_50"
    end
  end

  def style_value
    case value
    when "leading"
      if correct?
        "style_20"
      elsif mostly_wrong?
        "style_80"
      elsif mostly_right?
        "style_60"
      else
        "style_40"
      end
    when "off_pace"
      if correct?
        "style_40"
      elsif mostly_wrong?
        "style_80"
      elsif mostly_right?
        "style_60"
      else
        "style_20"
      end
    when "midpack"
      if correct?
        "style_60"
      elsif mostly_wrong?
        "style_20"
      elsif mostly_right?
        "style_40"
      else
        "style_80"
      end
    else
      if correct?
        "style_80"
      elsif mostly_wrong?
        "style_20"
      elsif mostly_right?
        "style_40"
      else
        "style_60"
      end
    end
  end

  def pissy_value
    case value
    when 1
      if correct?
        "pissy_20"
      elsif totally_wrong?
        "pissy_50"
      else
        "pissy_100"
      end
    when 2
      if correct?
        "pissy_50"
      elsif totally_wrong?
        "pissy_100"
      else
        "pissy_20"
      end
    when 3
      if correct?
        "pissy_50"
      elsif totally_wrong?
        "pissy_20"
      else
        "pissy_100"
      end
    when 4
      if correct?
        "pissy_50"
      elsif totally_wrong?
        "pissy_20"
      else
        "pissy_100"
      end
    when 5
      if correct?
        "pissy_100"
      elsif totally_wrong?
        "pissy_50"
      else
        "pissy_20"
      end
    end
  end

  def ratability_value
    case value
    when 1
      if correct?
        "ratability_20"
      elsif totally_wrong?
        "ratability_50"
      else
        "ratability_100"
      end
    when 2
      if correct?
        "ratability_50"
      elsif totally_wrong?
        "ratability_100"
      else
        "ratability_20"
      end
    when 3
      if correct?
        "ratability_50"
      elsif totally_wrong?
        "ratability_20"
      else
        "ratability_100"
      end
    when 4
      if correct?
        "ratability_50"
      elsif totally_wrong?
        "ratability_20"
      else
        "ratability_100"
      end
    when 5
      if correct?
        "ratability_100"
      elsif totally_wrong?
        "ratability_50"
      else
        "ratability_20"
      end
    end
  end

  def xp_value
    if value < 11
      "xp_10"
    elsif value < 31
      "xp_30"
    elsif value < 41
      "xp_40"
    elsif value < 61
      "xp_60"
    elsif value < 71
      "xp_70"
    else
      "xp_90"
    end
  end

  def confidence_value
    if value < 21
      "confidence_20"
    elsif value < 41
      "confidence_40"
    elsif value < 61
      "confidence_60"
    else
      "confidence_80"
    end
  end

  def natural_energy_value
    if value >= 80
      "natural_energy_80"
    elsif value >= 60
      "natural_energy_60"
    elsif value >= 40
      "natural_energy_40"
    elsif value >= 20
      "natural_energy_20"
    elsif value >= 0
      "natural_energy_0"
    else
      "natural_energy_negative"
    end
  end

  def correct?
    random_chance <= knowledge
  end

  def totally_wrong?
    knowledge < 50
  end

  def mostly_wrong?
    knowledge < 30
  end

  def mostly_right?
    knowledge < 60
  end

  def total_distance
    distance = 0
    (1..workout.activity_count).each do |index|
      distance += workout.send(:"distance#{index}") * 10
    end
    distance
  end

  def jockey_weight
    workout.jockey.weight
  end
end

