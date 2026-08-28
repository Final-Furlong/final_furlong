class Horses::AutobreedMaresJob < ApplicationJob
  queue_as :latency_5m

  def perform
    return unless valid_date?

    @studs = load_studs
    Breeding::Slot.order(month: :asc, start_day: :asc).find_each do |slot|
      next if run_today_for_slot?(slot:)

      slot_end_date = Date.new(Date.current.year, slot.month, slot.end_day)
      next if Date.current < slot_end_date

      open_studs = []
      @studs.each do |stud|
        next if stud[:last_race_date] && (stud[:last_race_date] + 1.day) > slot_end_date
        next if Horses::Breeding.where(stud_id: stud[:id]).current_year.bred.where(slot:).count >= Config::Breedings.mares_per_slot

        open_studs << stud
      end
      if open_studs.empty?
        next
      else
        Horses::AutobreedMaresForSlotJob.perform_later(slot_id: slot.id, stud_ids: open_studs.map { |stud| stud[:id] })
        break
      end
    end
  end

  private

  def valid_date?
    Breeding::Slot.order(month: :asc, start_day: :asc).find_each do |slot|
      current_year = Date.current.year
      slot_end_day = Date.new(current_year, slot.month, [Time.days_in_month(slot.month, current_year), slot.end_day].min)
      return false if slot_end_day >= Date.current

      day_diff = (Date.current - slot_end_day).to_i
      next if day_diff > 1
      return true if day_diff == 1
    end
    false
  end

  def run_today_for_slot?(slot:)
    JobStat.where("outcome ->> 'month' = ?", slot.month.to_s).where("outcome ->> 'day' = ?", slot.start_day.to_s).exists?(name: self.class.name, last_run_at: Date.current.all_day)
  end

  def load_studs
    return @studs if defined?(@studs)

    @studs = []
    base_query = Horses::Horse::Stud.where(state: "active")
    query = base_query.where(id: Horses::Horse::Stud.joins(:owner).where(owner: { name: Config::Game.stable }))
    query = query.or(base_query.where(id: base_query.joins(:stud_options).where(stud_options: { breed_to_game_mares: true })))
    @studs = query.all.map { |stud|
      { id: stud.id, last_race_date: stud.race_result_finishes.joins(:race).includes(:race).merge(::Racing::RaceResult.current_year.ordered_by_date(:desc)).first&.race&.date }
    }
    @studs
  end
end

