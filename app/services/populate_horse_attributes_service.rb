class PopulateHorseAttributesService # rubocop:disable Metrics/ClassLength
  # rubocop:disable Rails/Output
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    query = Horses::Horse.where.associated(:lifetime_race_record).where.missing(:horse_attributes)
    query.find_each(cursor: [:id], order: [:asc]) do |horse|
      update_horse(horse)
    end
    query = Horses::Horse.joins(:horse_attributes).where.associated(:lifetime_race_record).where(horse_attributes: { track_record: "Unraced" })
    query.find_each(cursor: [:id], order: [:asc]) do |horse|
      update_horse(horse)
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end

  private

  def update_horse(horse)
    horse_attributes = horse.horse_attributes || horse.build_horse_attributes
    record = horse.lifetime_race_record
    track_record = if record.stakes_wins > 1 && record.stakes_places > 1
      "Mult. Stakes Winner, Mult. Stakes Placed"
    elsif record.stakes_wins > 1 && record.stakes_places == 1
      "Mult. Stakes Winner, Stakes Placed"
    elsif record.stakes_wins == 1 && record.stakes_places > 1
      "Stakes Winner, Mult. Stakes Placed"
    elsif record.stakes_wins == 1 && record.stakes_places == 0
      "Stakes Winner, Stakes Placed"
    elsif record.stakes_wins > 1
      "Mult. Stakes Winner"
    elsif record.stakes_wins == 1
      "Stakes Winner"
    elsif record.stakes_places > 1
      "Mult. Stakes Placed"
    elsif record.stakes_places == 1
      "Stakes Placed"
    elsif record.wins > 1 && record.places > 1
      "Mult. Winner, Mult. Placed"
    elsif record.wins > 1 && record.places == 1
      "Mult. Winner, Placed"
    elsif record.wins == 1 && record.places > 1
      "Winner, Mult. Placed"
    elsif record.wins == 1 && record.places == 1
      "Winner, Placed"
    elsif record.wins > 1
      "Mult. Winner"
    elsif record.wins == 1
      "Winner"
    elsif record.places > 1
      "Mult. Placed"
    elsif record.places == 1
      "Placed"
    else
      "Unplaced"
    end
    if record.earnings >= 2_000_000
      track_record += ", Multi-Millionaire"
    elsif record.earnings >= 1_000_000
      track_record += ", Millionaire"
    end
    horse_attributes.update(track_record:)
  end

  # rubocop:enable Rails/Output
end

