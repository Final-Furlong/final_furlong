class Horses::AutobreedMaresForSlotJob < ApplicationJob
  queue_as :latency_5m

  attr_reader :studs, :slot, :slot_end_date

  def perform(slot_id:, stud_ids:)
    @slot = Breeding::Slot.find(slot_id)
    @slot_end_date = Date.new(Date.current.year, slot.month, slot.end_day)
    return if Date.current < slot_end_date

    completed_studs = 0
    total_booked_mares = 0
    @studs = Horses::Horse::Stud.where(id: stud_ids).order("RANDOM()")
    @studs.each do |stud|
      current_bookings = stud.breedings.current_year.bred.where(slot:).count
      needed_mares = Config::Breedings.mares_per_slot - current_bookings
      if needed_mares < 1
        completed_studs += 1
        next
      end

      notification_params = { slot: slot.formatted_range, mare_ids: [] }
      booked_mares = 0
      mares = find_mares(stud:, count: needed_mares)
      stud_horse = Horses::Horse.find(stud.id)
      mares.each do |mare|
        breeding = Horses::Breeding.find_or_initialize_by(year: Date.current.year, slot_id: slot.id, mare_id: mare.id, stud_id: stud.id, fee: 0, stable_id: stable.id)
        breeding.update(
          auto: true,
          date: Date.new(Date.current.year, slot.month, slot.end_day),
          status: "approved"
        )
        result = Horses::BreedingProcessor.new.do_breeding(breeding:, mare:, stud: stud_horse, auto: true)
        if result.updated?
          booked_mares += 1 # everything worked
          total_booked_mares += 1
          notification_params[:mare_ids] << mare.id
        else
          # something went wrong, ditch the breeding
          breeding.destroy
        end
        if booked_mares >= needed_mares
          completed_studs += 1
          break
        end
      end
      notify_owner(stud:, slot:, notification_params:)
    end
    next_slot = Breeding::Slot.ordered.to_a.find { |this_slot| this_slot.month == slot.month && this_slot.end_day > slot.end_day || this_slot.month > slot.month }
    if completed_studs < stud_ids.count || (next_slot && Date.current > Date.new(Date.current.year, next_slot.month, next_slot.end_day))
      Horses::AutobreedMaresJob.set(wait: 1.minute).perform_later
    else
      Horses::CreateBabiesJob.set(wait: 1.minute).perform_later
    end
    store_job_info(outcome: { studs: completed_studs, mares: total_booked_mares, month: slot.month, day: slot.start_day }, class_name: "Horses::AutobreedMaresJob")
  end

  private

  def notify_owner(stud:, slot:, notification_params:)
    return unless notification_params[:mare_ids].count.positive?

    Game::NotificationCreator.new.create_notification(
      type: ::Notifications::Breeding::Stud::AutoBredMaresNotification,
      user: stud.manager.user,
      params: notification_params.merge(
        horse_id: stud.slug,
        horse_name: stud.name
      )
    )
  end

  def stable
    return @stable if defined?(@stable)

    @stable = Account::Stable.find_by(name: Config::Game.stable)
  end

  def find_mares(stud:, count:)
    mares_foaled_last_year = Horses::Horse.with_yob(Date.current.year - 1).select(:dam_id).distinct
    mares_bred_to_this_stud = Horses::Horse.where(sire_id: stud.id).select(:dam_id).distinct
    base_query = Horses::Horse::Broodmare.where(state: "active").joins(:sire, :dam, :manager)
      .where(manager: stable)
      .where.not("horses.sire_id = :id OR sires_horses.sire_id = :id OR dams_horses.sire_id = :id", { id: stud.id })
      .where.missing(:next_foal)
      .where.not(id: mares_bred_to_this_stud)
    found_mares = []
    # platinum mares who didn't have a foal last year
    platinum_mares = base_query.joins(:foal_record).where(foal_record: { breed_ranking: "platinum" }).where.not(id: mares_foaled_last_year)
    if platinum_mares.count >= count
      platinum_mares.order("RANDOM()").limit(count).to_a.each do |plat_mare|
        if mare_ok?(plat_mare)
          found_mares << plat_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # gold mares who didn't have a foal last year
    gold_mares = base_query.joins(:foal_record).where(foal_record: { breed_ranking: "gold" }).where.not(id: mares_foaled_last_year)
    if gold_mares.count >= count
      gold_mares.order("RANDOM()").limit(count).to_a.each do |gold_mare|
        if mare_ok?(gold_mare)
          found_mares << gold_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # SW mares who didn't have a foal last year
    sw_mares = base_query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_winner).where.not(id: mares_foaled_last_year)
    if sw_mares.count >= count
      sw_mares.order("RANDOM()").limit(count).to_a.each do |sw_mare|
        if mare_ok?(sw_mare)
          found_mares << sw_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # platinum mares who did have a foal last year
    platinum_mares = base_query.joins(:foal_record).where(foal_record: { breed_ranking: "platinum" }).where(id: mares_foaled_last_year)
    if platinum_mares.count >= count
      platinum_mares.order("RANDOM()").limit(count).to_a.each do |plat_mare|
        if mare_ok?(plat_mare)
          found_mares << plat_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # gold mares who did have a foal last year
    gold_mares = base_query.joins(:foal_record).where(foal_record: { breed_ranking: "gold" }).where(id: mares_foaled_last_year)
    if gold_mares.count >= count
      gold_mares.order("RANDOM()").limit(count).to_a.each do |gold_mare|
        if mare_ok?(gold_mare)
          found_mares << gold_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # SW mares who did have a foal last year
    sw_mares = base_query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.stakes_winner).where(id: mares_foaled_last_year)
    if sw_mares.count >= count
      sw_mares.order("RANDOM()").limit(count).to_a.each do |sw_mare|
        if mare_ok?(sw_mare)
          found_mares << sw_mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # any mares who didn't have a foal last year
    mares = base_query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_winner).where.not(id: mares_foaled_last_year)
    if mares.count >= count
      mares.order("RANDOM()").limit(count).to_a.each do |mare|
        if mare_ok?(mare)
          found_mares << mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    # any mares who did have a foal last year
    mares = base_query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_winner).where(id: mares_foaled_last_year)
    if mares.count >= count
      mares.order("RANDOM()").limit(count).to_a.each do |mare|
        if mare_ok?(mare)
          found_mares << mare
        end
      end
    end
    return found_mares if found_mares.count >= count

    base_query = Horses::Horse::Broodmare.where(state: "active").joins(:sire, :dam, :manager)
      .where(manager: stable)
      .where.not("horses.sire_id = :id OR sires_horses.sire_id = :id OR dams_horses.sire_id = :id", { id: stud.id })
      .where.missing(:next_foal)
    mares = base_query.joins(:lifetime_race_record).merge(Racing::LifetimeRaceRecord.not_stakes_winner)
    if mares.count >= count
      mares.order("RANDOM()").limit(count).to_a.each do |mare|
        if mare_ok?(mare)
          found_mares << mare
        end
      end
    end
    found_mares
  end

  def mare_ok?(mare)
    last_race_date = mare.race_result_finishes.joins(:race).includes(:race).merge(::Racing::RaceResult.current_year.ordered_by_date(:desc)).first&.race&.date
    if last_race_date.present? && last_race_date <= slot_end_date
      false
    else
      last_sale_date = mare.sales.where(buyer: stable).order(date: :desc).first&.date
      if last_sale_date.blank? || last_sale_date <= slot_end_date
        last_foal_date = mare.foals.born.order(date_of_birth: :desc).first&.date_of_birth
        return true if last_foal_date.blank?

        (last_foal_date + Config::Breeding.min_days_delay_from_previous_foal.days) <= slot_end_date
      else
        false
      end
    end
  end
end

