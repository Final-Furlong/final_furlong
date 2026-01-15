module Workouts
  class WorkoutCreator
    def create_workout(horse:, jockey:, surface:,
      condition:, activity1:, distance1:, effort:, blinkers: false,
      shadow_roll: false, wraps: false, figure_8: false, no_whip: false,
      activity2: nil, distance2: nil, activity3: nil, distance3: nil)
      return if Racing::Workout.exists?(horse:, date: Date.current)

      workout = Racing::Workout.new(horse:, date: Date.current)
      workout.jockey = jockey
      workout.condition = condition
      workout.surface = surface.surface
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
      if workout.valid?
        event = pick_special_event
        if event == "cooperate"
          _confidence = 10
        elsif event != "none"
          # figure out what activity the event will occur in
          activity_count = if workout.activity3
            3
          elsif workout.activity2
            2
          else
            1
          end
          event_activity = rand(1...activity_count)
          furlong_time = workout.send(:"distance#{event_activity}") * 10
          _event_time = rand(5...furlong_time)
          _confidence = -20
        end
      end
      workout.blinkers = blinkers
      workout.shadow_roll = shadow_roll
      workout.wraps = wraps
      workout.figure_8 = figure_8
      workout.no_whip = no_whip
      workout.save
    end

    private

    ### AGE PERCENT MODIFIERS
    # $horse['Min'] = round($horse['Min'] * $horse['agePercent']);
    # $horse['Ave'] = round($horse['Ave'] * $horse['agePercent']);
    # $horse['Max'] = round($horse['Max'] * $horse['agePercent']);
    # $horse['Stamina'] = round($horse['Stamina'] * $horse['agePercent']);
    # $horse['Sustain'] = round($horse['Sustain'] * $horse['agePercent']);

    def pick_injury
      chance = rand(5 - horse.soundness...10)
      if workout.condition == "wet"
        chance += 2
      elsif workout.condition == "slow"
        chance += 3
      end
      if workout.jockey.weight > horse.weight
        difference_in_lbs = workout.jockey.weight - horse.weight
        chance += (difference_in_lbs < 5) ? 2 : 3
      end
      if horse.energy < 25
        chance += 5
      elsif horse.energy < 50
        chance += 3
      elsif horse.energy < 75
        chance += 1
      end
      if horse.fitness < 25
        chance += 5
      elsif horse.fitness < 40
        chance += 3
      elsif horse.fitness < 60
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
        case horse.soundness
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
          "bowed"
        elsif random_injury <= overheat
          "overheat"
        elsif random_injury <= limp
          "limp"
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
      spook_chance = 3
      if horse.experience < 20
        spook_chance += 3
      elsif horse.experience < 40
        spook_chance += 2
      elsif horse.experience < 60
        spook_chance += 1
      elsif horse.experience > 90
        spook_chance -= 2
      elsif horse.experience > 80
        spook_chance -= 1
      end

      dump_chance = 3
      if horse.energy > 90
        dump_chance += 3
      elsif horse.energy > 80
        dump_chance += 2
      elsif horse.energy > 70
        dump_chance += 1
      elsif horse.energy < 10
        dump_chance -= 2
      elsif horse.energy < 20
        dump_chance -= 1
      end

      bolt_chance = 3
      if horse.fitness > 90
        bolt_chance += 3
      elsif horse.fitness > 80
        bolt_chance += 2
      elsif horse.fitness > 70
        bolt_chance += 1
      elsif horse.fitness < 10
        bolt_chance -= 2
      elsif horse.fitness < 20
        bolt_chance -= 1
      end

      fight_chance = 3
      if horse.pissy > 4
        fight_chance += 2
      elsif horse.pissy > 3
        fight_chance += 1
      end

      cooperate_chance = 3
      if horse.ratability > 4
        cooperate_chance += 2
      elsif horse.ratability > 3
        cooperate_chance += 1
      end

      max_value_check = if horse.natural_energy <= 0
        50
      elsif horse.natural_energy <= 20
        70
      elsif horse.natural_energy <= 40
        100
      elsif horse.natural_energy <= 60
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
        "cooperate" # TODO: confidence =  10
      else
        "none"
      end
    end
  end
end

