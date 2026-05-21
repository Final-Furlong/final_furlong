class Horses::GrowthJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    return if run_today?

    horses_grown = 0
    fully_grown = 0
    step :process do |step|
      Horses::Horse.born.not_stillborn.joins(:racing_stats).includes(:racing_stats, :appearance).merge(::Racing::RacingStats.not_peaked).find_each(start: step.cursor) do |horse|
        stats = horse.racing_stats
        appearance = horse.appearance
        days_old = (Date.current - horse.date_of_birth).to_i
        birth_hands, birth_extra_inches = appearance.birth_height.to_s.split(".")
        birth_inches = (birth_hands.to_i * 4) + birth_extra_inches.to_i
        max_hands, max_extra_inches = appearance.max_height.to_s.split(".")
        max_inches = (max_hands.to_i * 4) + max_extra_inches.to_i
        growth_inches = max_inches - birth_inches
        stats.peak_start_date
        ((stats.peak_end_date - stats.peak_start_date).to_i / 2).days
        days_to_peak_start_date = (stats.peak_start_date - horse.date_of_birth).to_i
        days_per_inch = days_to_peak_start_date.fdiv(growth_inches).ceil
        inches_grown = days_old.fdiv(days_per_inch).floor
        current_height = birth_inches + inches_grown
        current_height = current_height.clamp(birth_inches, max_inches)
        appearance.update!(current_height: "#{current_height / 4}.#{current_height % 4}".to_f)
        horses_grown += 1
        step.advance! from: horse.id
      end
    end

    step :do_full_grown do |step|
      # rubocop:disable Rails/SkipsModelValidations
      fully_grown = Horses::Appearance.where(horse: Horses::Horse.born.not_stillborn.joins(:racing_stats).merge(::Racing::RacingStats.peaked)).update_all("current_height = max_height")
      # rubocop:enable Rails/SkipsModelValidations
    end

    store_job_info(outcome: { horses_grown:, fully_grown: })
  end
end

