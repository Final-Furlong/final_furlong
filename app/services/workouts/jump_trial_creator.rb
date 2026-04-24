module Workouts
  class JumpTrialCreator
    attr_reader :horse

    def run_trial(horse:)
      @horse = horse
      jockey

      trial_result = do_jumps
      racetrack = horse.race_metadata.racetrack
      condition = racetrack.surfaces.steeplechase.first.condition
      trial = Workouts::JumpTrial.new(horse:, date: Date.current, racetrack:, condition:, jockey:)
      trial.time_in_seconds = trial_result[:time]
      trial.comment = pick_comment
      result = Result.new(trial:, created: false)

      ActiveRecord::Base.transaction do
        relationship = Racing::HorseJockeyRelationship.find_or_initialize_by(horse:, jockey:)
        relationship.experience += rand(1..2)
        relationship.experience = relationship.experience.clamp(0, 100)
        relationship.happiness += rand(1..4)
        relationship.happiness = relationship.happiness.clamp(0, 100)
        relationship.save
        stats = horse.racing_stats
        stats.energy -= trial_result[:energy_loss]
        stats.energy = stats.energy.clamp(-50, 100)
        stats.fitness += trial_result[:fitness_gain]
        stats.fitness = stats.fitness.clamp(-50, 100)
        stats.save
        if (data = horse.race_metadata)
          energy_grade, fitness_grade = data.update_grades(energy: stats.energy, fitness: stats.fitness)
          data.update(workouts_since_last_race: data.workouts_since_last_race.to_i + 1)
        end
        Legacy::Horse.where(ID: horse.legacy_id).update(
          EnergyCurrent: stats.energy,
          Fitness: stats.fitness,
          DisplayEnergy: energy_grade,
          DisplayFitness: fitness_grade
        )
        result.created = trial.save!
        result.trial = trial
        result
      end
    end

    class Result
      attr_accessor :trial, :created, :error

      def initialize(created:, trial:, error: nil)
        @created = created
        @trial = trial
        @error = error
      end

      def created?
        @created
      end
    end

    private

    def baseline_info
      return @baseline_info if defined?(@baseline_info)

      rand(89..99)
      stats = horse.racing_stats
      steeplechase_mod = (100 - (5 - stats.steeplechase)).fdiv(100)
      @baseline_info = {
        strides_per_second: (stats.strides_per_second * rand(89..99).fdiv(100) * steeplechase_mod).round(2),
        stride_length: (stats.average_speed * rand(89..99).fdiv(100) * steeplechase_mod).round(2),
        confidence: ((11 - steeplechase_mod).fdiv(10) * 10)
      }
    end

    def do_jumps
      feet = 5280 * 12
      time = feet.fdiv(baseline_info[:stride_length] * baseline_info[:strides_per_second])
      energy_loss_per_second = rand((Config::Workouts.dig(:jump_trial, :energy_loss_per_second_min) * 1000)..(Config::Workouts.dig(:jump_trial, :energy_loss_per_second_max) * 1000))
      fitness_gain_per_second = rand((Config::Workouts.dig(:jump_trial, :fitness_gain_per_second_min) * 1000)..(Config::Workouts.dig(:jump_trial, :fitness_gain_per_second_max) * 1000))
      energy_loss = time * energy_loss_per_second
      fitness_gain = time * fitness_gain_per_second

      Config::Workouts.dig(:jump_trial, :jumps_number).times do |n|
        this_jump_time = rand((jump_time[:min] * 100)..(jump_time[:max] * 100)).fdiv(100)
        time += this_jump_time
        energy_loss += if horse.racing_stats.steeplechase < 5
          this_jump_time * 3
        elsif horse.racing_stats.steeplechase < 8
          this_jump_time * 2
        else
          this_jump_time
        end
      end
      {
        energy_loss: energy_loss.round,
        fitness_gain: fitness_gain.fdiv(10).to_i,
        time: time.floor
      }
    end

    def jump_time
      return @jump_time if defined?(@jump_time)

      max_time = (4 - ((horse.racing_stats.steeplechase - 1) * 0.2)).to_f
      min_time = max_time - 0.3
      @jump_time = { min: min_time.abs, max: max_time.abs }
    end

    def pick_comment
      Workouts::Comment.find_by(stat: "jumps", stat_value: jockey_feedback)
    end

    def jockey_feedback
      knowledge = horse.jockey_relationships.maximum(:experience)
      knowledge = knowledge.clamp(10, 90)

      random_chance = rand(1..100)
      if horse.racing_stats.steeplechase < 3
        (random_chance < knowledge) ? 20 : 40
      elsif horse.racing_stats.steeplechase < 5
        if random_chance < knowledge
          40
        elsif knowledge < 50
          60
        else
          20
        end
      elsif horse.racing_stats.steeplechase < 8
        if random_chance < knowledge
          60
        elsif knowledge < 50
          80
        else
          40
        end
      elsif random_chance < knowledge
        80
      elsif knowledge < 50
        40
      else
        60
      end
    end

    def jockey
      return @jockey if defined?(@jockey)

      @jockey = Racing::Jockey.active.jump.order("RANDOM()").first
    end
  end
end

