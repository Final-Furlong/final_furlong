module Workouts
  class WorkoutCreator
    attr_reader :horse, :workout

    def create_workout(horse:, jockey:, surface:, params: {})
      activity1 = params[:activity1]
      distance1 = params[:distance1]
      activity2 = params[:activity2]
      distance2 = params[:distance2]
      activity3 = params[:activity3]
      distance3 = params[:distance3]
      effort = params[:effort]
      blinkers = params[:blinkers]
      shadow_roll = params[:shadow_roll]
      wraps = params[:wraps]
      figure_8 = params[:figure_8]
      no_whip = params[:no_whip]

      @horse = horse
      return if Racing::Workout.exists?(horse:, date: Date.current)

      @workout = Racing::Workout.new(horse:, date: Date.current)
      result = Result.new(created: false, workout: @workout)
      workout.jockey = jockey
      workout.condition = surface.condition
      workout.surface = surface
      workout.racetrack = surface.racetrack
      workout.location = workout.racetrack.location
      workout.effort = effort
      workout.activity1 = activity1
      workout.distance1 = distance1
      if activity2.present?
        workout.activity2 = activity2
        workout.distance2 = distance2
      end
      if activity3.present?
        workout.activity3 = activity3
        workout.distance3 = distance3
      end
      workout.confidence = 0
      if workout.valid?
        workout.special_event = pick_special_event
        event_activity = 0
        if workout.special_event == "cooperate"
          workout.confidence = 10
        elsif workout.special_event != "none"
          event_activity = rand(1...workout.activity_count)
          furlong_time = workout.send(:"distance#{event_activity}") * 10
          workout.special_event_time = rand(5...furlong_time)
          workout.confidence = -20
        end
        workout.energy_loss = 0
        workout.fitness_gain = 0
        workout.time_in_seconds = 0
        workout.total_time_in_seconds = 0
        (1...workout.activity_count).each do |activity_number|
          do_activity(activity_number, event_activity == activity_number)
        end
        calculate_energy_loss
        calculate_fitness_gain
        workout.comment = pick_comment
        pd workout.comment.inspect
        workout.confidence += rand(1...70)
        workout.blinkers = blinkers
        workout.shadow_roll = shadow_roll
        workout.wraps = wraps
        workout.figure_8 = figure_8
        workout.no_whip = no_whip
        ActiveRecord::Base.transaction do
          relationship = Racing::HorseJockeyRelationship.find_or_initialize_by(horse: workout.horse, jockey: workout.jockey)
          relationship.experience += gained_xp
          relationship.experience = 100 if relationship.experience > 100
          relationship.happiness += gained_happiness
          relationship.save
          stats = horse.racing_stats
          stats.energy -= workout.energy_loss
          stats.energy = stats.energy.clamp(-50, 100)
          stats.fitness += workout.fitness_gain
          stats.fitness = stats.fitness.clamp(-50, 100)
          stats.save
          horse.race_metadata.update_grades(energy: stats.energy, fitness: stats.fitness)
          pick_and_save_injury
          workout.valid?(context: :complete_workout)
          result.created = workout.save
        end
        result.workout = workout
      else
        result.workout = workout
      end
      result
    end

    class Result
      attr_accessor :workout, :created

      def initialize(created:, workout:)
        @created = created
        @workout = workout
      end

      def created?
        @created
      end
    end

    private

    def pick_and_save_injury
      return unless (injury = pick_injury)

      Horses::Injury.create!(
        horse:,
        date: workout.date,
        injury_type: injury,
        rest_date: workout.date + Horses::Injury.rest_days(injury).days
      )
      Horses::HistoricalInjury.create!(
        horse:,
        date: workout.date,
        injury_type: injury,
        leg: Horses::Injury.pick_leg(injury)
      )
      horse.training_schedules_horse.destroy
      horse.training_schedule.destroy
    end

    def gained_happiness
      if workout.special_event == "cooperate"
        4
      elsif workout.special_event == "none"
        -2
      elsif workout.confidence > 74
        2
      elsif workout.confidence < 26
        -1
      else
        1
      end
    end

    def gained_xp
      (workout.confidence < 26 || workout.confidence > 74) ? 2 : 1
    end

    def calculate_energy_loss
      workout.energy_loss *= (0.5 + (1 - horse.racing_stats.peak_percent))
    end

    def calculate_fitness_gain
      workout.fitness_gain *= (0.8 + (0.2 * horse.racing_stats.fitness.fdiv(100)))
      if workout.fitness_gain > workout.energy_loss.abs * 10
        workout.fitness_gain = workout.energy_loss.abs * 10
      end
    end

    def pick_comment
      if workout.special_event != "none"
        Racing::WorkoutComment.find_by(stat: workout.special_event.to_s.downcase)
      else
        stat = if horse.racing_stats.natural_energy_current <= 10 && rand(1...2) == 1
          "natural_energy"
        else
          query = Racing::WorkoutComment.where.not(stat_value: nil).where.not(stat: "jumps")
          query.order("RANDOM()").first.stat
        end
        knowledge = Racing::HorseJockeyRelationship.find_or_initialize_by(horse: workout.horse, jockey: workout.jockey).experience
        WorkoutCommentGenerator.new(workout:, knowledge:, stat:, value: pick_stat_value(stat)).call
      end
    end

    def pick_stat_value(stat)
      case stat.to_s.downcase
      when "equipment"
        equipment_status
      when "stamina"
        horse.racing_stats.stamina * horse.racing_stats.peak_percent
      when "energy"
        horse.racing_stats.energy
      when "fitness"
        horse.racing_stats.fitness
      when "happy"
        Racing::HorseJockeyRelationship.find_or_initialize_by(horse: workout.horse, jockey: workout.jockey).happiness
      when "weight"
        horse.racing_stats.weight
      when "style"
        leading = horse.racing_stats.leading
        off_pace = horse.racing_stats.off_pace
        midpack = horse.racing_stats.midpack
        closing = horse.racing_stats.closing
        if leading >= off_pace && leading >= midpack && leading >= closing
          "leading"
        elsif off_pace >= midpack && off_pace >= closing
          "off_pace"
        elsif midpack >= closing
          "midpack"
        else
          "closing"
        end
      when "pissy"
        horse.racing_stats.pissy
      when "ratability"
        horse.racing_stats.ratability
      when "xp"
        Racing::HorseJockeyRelationship.find_or_initialize_by(horse: workout.horse, jockey: workout.jockey).experience
      when "confidence"
        workout.confidence
      when "jumps"
        horse.racing_stats.steeplechase
      when "natural_energy"
        horse.racing_stats.natural_energy_current
      end
    end

    def do_activity(index, do_special_event = false)
      activity = workout.send(:"activity#{index}").downcase.to_sym
      # rubocop:disable Style/IdenticalConditionalBranches
      time = if do_special_event
        activity_time = workout.special_event_time
        workout.energy_loss += activity_time * pick_energy_loss(activity)
        workout.energy_loss += rand(10...20) # extra lost energy for the event
        workout.fitness_gain += activity_time * pick_fitness_gain(activity)
        activity_time
      else
        activity_time = workout.send(:"distance#{index}") * 660 * 12 # get distance in inches
        activity_time = activity_time.fdiv(stride_length(activity))
        workout.energy_loss += activity_time * pick_energy_loss(activity)
        workout.fitness_gain += activity_time + pick_fitness_gain(activity)
        activity_time /= strides_per_second(activity)
        activity_time
      end
      # rubocop:enable Style/IdenticalConditionalBranches
      workout.send("activity#{index}_time_in_seconds=", time)
      workout.time_in_seconds += time
      workout.total_time_in_seconds += time
    end

    def stride_length(activity)
      StrideLengthCalculator.new(
        activity:,
        stride_length: pick_stride_length(activity),
        effort: workout.effort,
        weight: weight_modifier,
        equipment_status:,
        track_preference:,
        track_condition:,
        consistency:
      ).call
    end

    def strides_per_second(activity)
      StridesPerSecondCalculator.new(
        activity:,
        strides_per_second: pick_strides_per_second(activity),
        effort: workout.effort,
        weight: weight_modifier,
        equipment_status:,
        track_preference:,
        track_condition:,
        consistency:
      ).call
    end

    def weight_modifier
      @weight_modifier ||= Workouts::WeightCarriedCalculator.new(workout.jockey.weight, horse.racing_stats.weight).call
    end

    def consistency
      @consistency ||= Racing::ConsistencyCalculator.new(consistency: horse.racing_stats.consistency).call
    end

    def track_condition
      @track_condition ||= Racing::TrackConditionPreferenceCalculator.new(
        track_condition: workout.condition, fast: horse.racing_stats.track_fast,
        good: horse.racing_stats.track_good, wet: horse.racing_stats.track_wet,
        slow: horse.racing_stats.track_slow
      ).call
    end

    def track_preference
      @track_preference ||= Racing::TrackTypePreferenceCalculator.new(
        track_type: workout.surface.surface, dirt: horse.racing_stats.dirt,
        turf: horse.racing_stats.turf, steeplechase: horse.racing_stats.steeplechase
      ).call
    end

    def equipment_status
      return @equipment_status if @equipment_status

      status = Racing::EquipmentStatusGenerator.new(current_equipment: workout.equipment, desired_equipment: horse.racing_stats.desired_equipment).call
      @equipment_status = Racing::EquipmentStatusGenerator::STATUS_MODIFIERS[status]
    end

    def pick_fitness_gain(activity)
      case activity
      when :walk
        min = Config::Workouts.dig(:walk, :fitness_gain_per_second_min) * 1000
        max = Config::Workouts.dig(:walk, :fitness_gain_per_second_max) * 1000
      when :jog, :trot
        min = Config::Workouts.dig(:jog, :fitness_gain_per_second_min) * 1000
        max = Config::Workouts.dig(:jog, :fitness_gain_per_second_max) * 1000
      when :canter
        min = Config::Workouts.dig(:canter, :fitness_gain_per_second_min) * 1000
        max = Config::Workouts.dig(:canter, :fitness_gain_per_second_max) * 1000
      when :gallop
        min = Config::Workouts.dig(:gallop, :fitness_gain_per_second_min) * 1000
        max = Config::Workouts.dig(:gallop, :fitness_gain_per_second_max) * 1000
      when :breeze
        min = Config::Workouts.dig(:breeze, :fitness_gain_per_second_min) * 1000
        max = Config::Workouts.dig(:breeze, :fitness_gain_per_second_max) * 1000
      end
      rand(min...max).fdiv(1000)
    end

    def pick_energy_loss(activity)
      case activity
      when :walk
        min = Config::Workouts.dig(:walk, :energy_loss_per_second_min) * 1000
        max = Config::Workouts.dig(:walk, :energy_loss_per_second_max) * 1000
      when :jog, :trot
        min = Config::Workouts.dig(:jog, :energy_loss_per_second_min) * 1000
        max = Config::Workouts.dig(:jog, :energy_loss_per_second_max) * 1000
      when :canter
        min = Config::Workouts.dig(:canter, :energy_loss_per_second_min) * 1000
        max = Config::Workouts.dig(:canter, :energy_loss_per_second_max) * 1000
      when :gallop
        min = Config::Workouts.dig(:gallop, :energy_loss_per_second_min) * 1000
        max = Config::Workouts.dig(:gallop, :energy_loss_per_second_max) * 1000
      when :breeze
        min = Config::Workouts.dig(:breeze, :energy_loss_per_second_min) * 1000
        max = Config::Workouts.dig(:breeze, :energy_loss_per_second_max) * 1000
      end
      rand(min...max).fdiv(1000)
    end

    def pick_stride_length(activity)
      case activity
      when :walk
        min = Config::Workouts.dig(:walk, :stride_inches_min)
        max = Config::Workouts.dig(:walk, :stride_inches_max)
        (rand(min...max) * 10).fdiv(10)
      when :jog, :trot
        min = Config::Workouts.dig(:jog, :stride_inches_min)
        max = Config::Workouts.dig(:jog, :stride_inches_max)
        (rand(min...max) * 10).fdiv(10)
      when :canter
        min = Config::Workouts.dig(:canter, :stride_inches_min)
        max = Config::Workouts.dig(:canter, :stride_inches_max)
        (rand(min...max) * 10).fdiv(10)
      when :gallop
        percent = rand(89...99)
        key = Config::Workouts.dig(:gallop, :stride_length)
        speed = horse.racing_stats.send(:"#{key}_speed")
        speed *= horse.racing_stats.peak_percent
        speed * percent.fdiv(100)
      when :breeze
        percent = rand(89...99)
        key = Config::Workouts.dig(:breeze, :stride_length)
        speed = horse.racing_stats.send(:"#{key}_speed")
        speed *= horse.racing_stats.peak_percent
        speed * percent.fdiv(100)
      end
    end

    def pick_strides_per_second(activity)
      case activity
      when :walk
        min = Config::Workouts.dig(:walk, :strides_per_second_min)
        max = Config::Workouts.dig(:walk, :strides_per_second_max)
        (rand(min...max) * 10).fdiv(10)
      when :jog, :trot
        min = Config::Workouts.dig(:jog, :strides_per_second_min)
        max = Config::Workouts.dig(:jog, :strides_per_second_max)
        (rand(min...max) * 10).fdiv(10)
      when :canter
        min = Config::Workouts.dig(:canter, :strides_per_second_min)
        max = Config::Workouts.dig(:canter, :strides_per_second_max)
        (rand(min...max) * 10).fdiv(10)
      when :gallop
        percent = rand(89...99)
        horse.racing_stats.strides_per_second * percent.fdiv(100)
      when :breeze
        percent = rand(89...99)
        horse.racing_stats.strides_per_second * percent.fdiv(100)
      end
    end

    def pick_injury
      stats = horse.racing_stats
      chance = rand(5 - stats.soundness...10)
      if workout.condition == "wet"
        chance += 2
      elsif workout.condition == "slow"
        chance += 3
      end
      if workout.jockey.weight > stats.weight
        difference_in_lbs = workout.jockey.weight - stats.weight
        chance += (difference_in_lbs < 5) ? 2 : 3
      end
      if stats.energy < 25
        chance += 5
      elsif stats.energy < 50
        chance += 3
      elsif stats.energy < 75
        chance += 1
      end
      if stats.fitness < 25
        chance += 5
      elsif stats.fitness < 40
        chance += 3
      elsif stats.fitness < 60
        chance += 1
      end
      extra_points = injury_points_for_activity(workout.activity1)
      extra_points += injury_points_for_activity(workout.activity2)
      extra_points += injury_points_for_activity(workout.activity3)
      chance += extra_points.fdiv(100).floor
      if chance > 100
        chance = 100
      end
      random_number = rand(1...5000)
      if random_number < chance
        # trigger an injury
        bowed_tendon = 14
        overheat = 31
        limp = 53
        cut = 69
        swelling = 82
        heat = 100
        case stats.soundness
        when 10
          bowed_tendon = 5
          overheat = 15
          limp = 30
          cut = 50
          swelling = 73
          heat = 100
        when 9
          bowed_tendon = 5
          overheat = 17
          limp = 34
          cut = 54
          swelling = 76
          heat = 100
        when 8
          bowed_tendon = 7
          overheat = 20
          limp = 41
          cut = 63
          swelling = 81
          heat = 100
        when 7
          bowed_tendon = 8
          overheat = 21
          limp = 39
          cut = 60
          swelling = 80
          heat = 100
        when 6
          bowed_tendon = 9
          overheat = 21
          limp = 39
          cut = 60
          swelling = 80
          heat = 100
        when 5
          bowed_tendon = 10
          overheat = 24
          limp = 42
          cut = 63
          swelling = 81
          heat = 100
        when 4
          bowed_tendon = 11
          overheat = 26
          limp = 46
          cut = 64
          swelling = 81
          heat = 100
        when 3
          bowed_tendon = 12
          overheat = 29
          limp = 50
          cut = 67
          swelling = 82
          heat = 100
        when 2
          bowed_tendon = 13
          overheat = 31
          limp = 53
          cut = 69
          swelling = 83
          heat = 100
        end
        random_injury = rand(1...350)
        if random_injury <= bowed_tendon
          "bowed tendon"
        elsif random_injury <= overheat
          "overheat"
        elsif random_injury <= limp
          "limping"
        elsif random_injury <= cut
          "cut"
        elsif random_injury <= swelling
          "swelling"
        elsif random_injury <= heat
          "heat"
        end
      end
    end

    def injury_points_for_activity(activity)
      case activity
      when "walk"
        2
      when "jog"
        4
      when "canter"
        6
      when "gallop"
        12
      when "breeze"
        75
      else
        0
      end
    end

    def pick_special_event
      stats = horse.racing_stats
      spook_chance = 3
      if stats.xp_current < 20
        spook_chance += 3
      elsif stats.xp_current < 40
        spook_chance += 2
      elsif stats.xp_current < 60
        spook_chance += 1
      elsif stats.xp_current > 90
        spook_chance -= 2
      elsif stats.xp_current > 80
        spook_chance -= 1
      end

      dump_chance = 3
      if stats.energy > 90
        dump_chance += 3
      elsif stats.energy > 80
        dump_chance += 2
      elsif stats.energy > 70
        dump_chance += 1
      elsif stats.energy < 10
        dump_chance -= 2
      elsif stats.energy < 20
        dump_chance -= 1
      end

      bolt_chance = 3
      if stats.fitness > 90
        bolt_chance += 3
      elsif stats.fitness > 80
        bolt_chance += 2
      elsif stats.fitness > 70
        bolt_chance += 1
      elsif stats.fitness < 10
        bolt_chance -= 2
      elsif stats.fitness < 20
        bolt_chance -= 1
      end

      fight_chance = 3
      if stats.pissy > 4
        fight_chance += 2
      elsif stats.pissy > 3
        fight_chance += 1
      end

      cooperate_chance = 3
      if stats.ratability > 4
        cooperate_chance += 2
      elsif stats.ratability > 3
        cooperate_chance += 1
      end

      max_value_check = if stats.natural_energy_current <= 0
        50
      elsif stats.natural_energy_current <= 20
        70
      elsif stats.natural_energy_current <= 40
        100
      elsif stats.natural_energy_current <= 60
        130
      else
        150
      end

      event_number = rand(1...max_value_check)
      if event_number <= spook_chance
        "spook"
      elsif event_number <= spook_chance + 1 + dump_chance
        "dump"
      elsif event_number <= spook_chance + 1 + dump_chance + bolt_chance
        "bolt"
      elsif event_number <= spook_chance + 1 + dump_chance +
          bolt_chance + fight_chance
        "fight"
      elsif event_number <= spook_chance + 1 + dump_chance +
          bolt_chance + fight_chance + cooperate_chance
        "cooperate"
      else
        "none"
      end
    end
  end
end

