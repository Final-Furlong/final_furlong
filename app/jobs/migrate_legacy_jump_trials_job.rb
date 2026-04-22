class MigrateLegacyJumpTrialsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    step :process do |step|
      Legacy::JumpTrial.find_each(start: step.cursor) do |legacy_jt|
        legacy_jt.destroy and next if legacy_jt.Location.zero?

        horse = Horses::Horse.find_by(legacy_id: legacy_jt.Horse)
        next unless horse.racehorse?

        count = Workouts::JumpTrial.count
        migrate_jump_trial(legacy_jt, horse)
        new_count = Workouts::JumpTrial.count
        legacy_jt.destroy if new_count > count

        step.advance! from: legacy_jt.id
      end
    end
  end

  private

  def migrate_jump_trial(legacy_trial, horse)
    trial = Workouts::JumpTrial.find_or_initialize_by(horse:, date: legacy_trial.Date - 4.years)
    trial.racetrack = Racing::Racetrack.find_by(name: Legacy::Racetrack.find(legacy_trial.Location).Name)
    trial.jockey = Racing::Jockey.find_by(legacy_id: legacy_trial.Jockey)
    trial.distance = legacy_trial.Distance
    trial.condition = case legacy_trial.Condition
    when 1
      "fast"
    when 3
      "good"
    when 5
      "wet"
    else
      "slow"
    end
    time_splits = legacy_trial.Time.split(":")
    time_in_seconds = time_splits.first.to_i * 60
    time_in_seconds += time_splits.last.to_i
    trial.time_in_seconds = time_in_seconds
    trial.comment = pick_comment(legacy_trial.Comment)
    trial.save!
  end

  def pick_comment(id)
    i18n_key = case id
    when 47
      "jumps_80"
    when 48
      "jumps_60"
    when 49
      "jumps_40"
    when 50
      "jumps_20"
    end
    Workouts::Comment.find_by(comment_i18n_key: i18n_key)
  end
end

