class Horses::CreateFoalJob < ApplicationJob
  queue_as :latency_30s

  attr_reader :breeding, :stable, :premature, :inbreeding, :sire_bpf, :dam_bpf

  def perform(id:)
    @breeding = Horses::Breeding.find(id)
    return unless breeding
    return unless breeding.status == "bred"
    return if breeding.first_foal
    @stable = breeding.stable
    @sire_bpf = breeding.stud.breeding_stats.breeding_potential
    @dam_bpf = breeding.mare.breeding_stats.breeding_potential

    if breeding.event.blank?
      breeding.event = pick_event
    end

    do_mare_death = false
    ActiveRecord::Base.transaction do
      gender = pick_gender
      calculate_inbreeding(breeding.stud, breeding.mare)
      date_of_birth = pick_date_of_birth(gender)
      horse = Horses::Horse::Foal.create!(
        sire: breeding.stud, dam: breeding.mare, date_of_birth:, location_bred:, breeder: stable, owner: stable, manager: stable,
        age: Date.current.year - date_of_birth.year, gender:, name: nil, state: "unborn", leaser_id: nil
      )
      horse.date_of_death = date_of_birth if breeding.event == "stillborn"
      horse.generate_allele
      horse.reload
      horse.generate_appearance
      if breeding.event == "birth" || breeding.event == "death" || breeding.event.starts_with?("twins")
        generate_future_events(horse:, date_of_birth:, gender:)
        foal_quality = determine_foal_quality(horse:)
        horse.reload
        stats = generate_racing_stats(horse:, quality: foal_quality)
        horse.genetics.update(soundness: stats.soundness, quality: foal_quality)
        generate_breeding_stats(horse:, quality: foal_quality)
        create_racehorse_metadata(horse:)
        breeding.first_foal = horse
        do_mare_death = true if breeding.event == "death"
      end
      if breeding.event.starts_with?("twins")
        gender = pick_gender
        twin = Horses::Horse::Foal.create!(
          sire: breeding.stud, dam: breeding.mare, date_of_birth:, location_bred:, breeder: stable, owner: stable, manager: stable,
          age: Date.current.year - date_of_birth.year, gender:, name: nil, state: "unborn", leaser_id: nil
        )
        twin.generate_allele
        twin.reload
        twin.generate_appearance
        twin.reload
        generate_future_events(horse: twin, date_of_birth:, gender:)
        foal_quality = determine_foal_quality(horse: twin)
        stats = generate_racing_stats(horse: twin, quality: foal_quality)
        twin.genetics.update(soundness: stats.soundness, quality: foal_quality)
        generate_breeding_stats(horse: twin, quality: foal_quality)
        create_racehorse_metadata(horse: twin)
        breeding.second_foal = twin
        do_mare_death = true if breeding.event == "twins_death"
      end
      if do_mare_death
        death_event = Horses::FutureEvent.find_or_initialize_by(horse: breeding.mare, event_type: "die")
        death_event.update(date: date_of_birth)
      end
      breeding.save
    end
  end

  private

  def create_racehorse_metadata(horse:)
    racetrack = horse.owner.racetrack
    Racing::RacehorseMetadata.create!(
      horse:, at_home: true, in_transit: false, currently_injured: false,
      energy_grade: "A", fitness_grade: "A", location_string: horse.owner.name,
      location: racetrack.location, racetrack:
    )
  end

  def generate_breeding_stats(horse:, quality:)
    breeding_potential = generate_breeding_potential(horse, quality)
    breeding_potential_grandparent = generate_breeding_potential_grandparent(breeding_potential)
    Horses::BreedingStats.create!(
      horse:,
      breeding_potential:,
      breeding_potential_grandparent:
    )
  end

  def generate_breeding_potential(horse, quality)
    potentials = []
    sire_bpf.times do |n|
      potentials << sire_bpf
    end
    dam_bpf.times do |n|
      potentials << dam_bpf
    end
    max_potential_range = 10
    case quality
    when 9, 10
      min_potential = (max_potential_range * 0.7).floor
      max_potential = max_potential_range
    when 7, 8
      min_potential = (max_potential_range * 0.6).floor
      max_potential = (max_potential_range * 0.9).floor
    when 5, 6
      min_potential = (max_potential_range * 0.5).floor
      max_potential = (max_potential_range * 0.8).floor
    when 3, 4
      min_potential = (max_potential_range * 0.4).floor
      max_potential = (max_potential_range * 0.7).floor
    else
      min_potential = (max_potential_range * 0.3).floor
      max_potential = (max_potential_range * 0.6).floor

    end
    (30 - potentials.count).times do
      potentials << rand(min_potential..max_potential)
    end
    potentials.sum(0).fdiv(30).round.clamp(1, 10)
  end

  def generate_breeding_potential_grandparent(breeding_potential)
    percent = 100
    potential = if percent < 55
      rand(1..5)
    elsif percent <= 75
      6
    elsif percent <= 85
      7
    elsif percent <= 92
      8
    elsif percent <= 97
      9
    else
      10
    end

    if breeding_potential < 5 && rand(0..1) == 0
      potential += rand(1..2)
    elsif breeding_potential > 7 && rand(0..1) == 0
      potential -= rand(1..2)
    end
    potential.clamp(1, 10)
  end

  def generate_future_events(horse:, date_of_birth:, gender:)
    retire_date = generate_retirement_date(date_of_birth, gender)
    death_date = generate_death_date(date_of_birth)

    if death_date > retire_date
      Horses::FutureEvent.create!(horse:, event_type: "retire", date: retire_date)
    end
    Horses::FutureEvent.create!(horse:, event_type: "die", date: death_date)
  end

  def generate_death_date(date_of_birth)
    death_age = rand(15..25)
    if rand(1..3) < 3
      death_age += rand(1..2)
    elsif rand(1..3) == 1
      death_age -= rand(1..2)
    end

    death_year = date_of_birth.year + death_age
    death_month = rand(1..12)
    death_day = rand(1..Time.days_in_month(death_month, death_year))
    Date.new(death_year, death_month, death_day)
  end

  def generate_retirement_date(date_of_birth, gender)
    retire_age = if gender == "colt"
      rand(12..18)
    else
      rand(17..23)
    end
    if rand(1..3) < 3
      retire_age += rand(1..2)
    else
      retire_age -= rand(1..2)
    end

    retire_year = date_of_birth.year + retire_age
    retire_month = rand(1..12)
    retire_day = rand(1..Time.days_in_month(retire_month, retire_year))
    Date.new(retire_year, retire_month, retire_day)
  end

  def generate_racing_stats(horse:, quality:)
    weight = generate_stat(:weight, horse, quality)
    if horse.appearance.max_height < 15.2
      weight -= rand(1..5)
    elsif horse.appearance.max_height > 16.3
      weight += rand(1..5)
    end
    weight.clamp(Config::Racing.dig(:stats, :weight, :min), Config::Racing.dig(:stats, :weight, :max))
    peak_start_date = generate_peak_start_date(horse)
    stats = Racing::RacingStats.create!(
      horse:,
      acceleration: generate_stat(:acceleration, horse, quality),
      average_speed: generate_stat(:average_speed, horse, quality),
      break_speed: generate_stat(:break_speed, horse, quality),
      closing: generate_stat(:closing, horse, quality),
      consistency: generate_stat(:consistency, horse, quality),
      courage: generate_stat(:courage, horse, quality),
      dirt: generate_stat(:dirt, horse, quality),
      energy: 100,
      energy_regain: generate_stat(:energy_regain, horse, quality),
      fitness: 100,
      leading: generate_stat(:leading, horse, quality),
      loaf_percent: generate_stat(:loaf_percent, horse, quality),
      loaf_threshold: generate_stat(:loaf_threshold, horse, quality),
      max_speed: generate_stat(:max_speed, horse, quality),
      midpack: generate_stat(:midpack, horse, quality),
      min_speed: generate_stat(:min_speed, horse, quality),
      natural_energy_current: 100.0,
      natural_energy_gain: generate_stat(:natural_energy_gain, horse, quality).fdiv(1000),
      natural_energy_loss: generate_stat(:natural_energy_loss, horse, quality),
      off_pace: generate_stat(:off_pace, horse, quality),
      peak_start_date:,
      peak_end_date: generate_peak_end_date(horse, quality, peak_start_date),
      pissy: generate_stat(:pissy, horse, quality),
      ratability: generate_stat(:ratability, horse, quality),
      soundness: generate_stat(:soundness, horse, quality) - inbred_soundness,
      stamina: generate_stat(:stamina, horse, quality),
      steeplechase: generate_stat(:steeplechase, horse, quality),
      strides_per_second: generate_stat(:strides_per_second, horse, quality).fdiv(1000),
      sustain: generate_stat(:sustain, horse, quality),
      track_fast: generate_stat(:track_fast, horse, quality),
      track_good: generate_stat(:track_good, horse, quality),
      track_slow: generate_stat(:track_slow, horse, quality),
      track_wet: generate_stat(:track_wet, horse, quality),
      traffic: generate_stat(:traffic, horse, quality),
      turf: generate_stat(:turf, horse, quality),
      turning: generate_stat(:turning, horse, quality),
      weight:,
      xp_current: 0,
      xp_rate: generate_stat(:xp_rate, horse, quality)
    )
    stats.pick_desired_equipment
    stats
  end

  def generate_peak_end_date(horse, quality, start_date)
    days = []
    sire_days = (horse.sire.racing_stats.peak_end_date - horse.sire.racing_stats.peak_start_date).to_i
    sire_bpf.times do |n|
      days << sire_days
    end
    dam_days = (horse.dam.racing_stats.peak_end_date - horse.dam.racing_stats.peak_start_date).to_i
    dam_bpf.times do |n|
      days << dam_days
    end
    min_day_range = Config::Racing.dig(:stats, :peak_length_days, :min)
    max_day_range = Config::Racing.dig(:stats, :peak_length_days, :max)
    case quality
    when 9, 10
      min_day = (max_day_range * 0.75).floor
      max_day = max_day_range
    when 7, 8
      min_day = (max_day_range * 0.65).floor
      max_day = (max_day_range * 0.90).floor
    when 5, 6
      min_day = (max_day_range * 0.55).floor
      max_day = (max_day_range * 0.80).floor
    when 3, 4
      min_day = (max_day_range * 0.45).floor
      max_day = (max_day_range * 0.70).floor
    else
      min_day = (max_day_range * 0.35).floor
      max_day = (max_day_range * 0.60).floor
    end
    (30 - days.count).times do
      days << rand(min_day..max_day)
    end
    peak_length = days.sum(0).fdiv(30).round.clamp(min_day_range, max_day_range)
    start_date + peak_length.days
  end

  def generate_peak_start_date(horse)
    days = []
    sire_days = (horse.sire.racing_stats.peak_start_date - horse.sire.date_of_birth).to_i
    sire_bpf.times do |n|
      days << sire_days
    end
    dam_days = (horse.dam.racing_stats.peak_start_date - horse.dam.date_of_birth).to_i
    dam_bpf.times do |n|
      days << dam_days
    end
    min_day_range = Config::Racing.dig(:stats, :peak_start_age_days, :min)
    max_day_range = Config::Racing.dig(:stats, :peak_start_age_days, :max)
    (30 - days.count).times do
      days << rand(min_day_range..max_day_range)
    end
    days_old = days.sum(0).fdiv(30).round.clamp(min_day_range, max_day_range)
    horse.date_of_birth + days_old.days
  end

  def generate_stat(stat, horse, quality)
    record = (stat.to_sym == :soundness) ? :genetics : :racing_stats
    # parents = 32 slots = sire (* bpf) + dam (* bpf) + 2+ random + inbreeding
    parent_stats = []
    # up to 15 for sire based on BPF
    sire_bpf.times do |n|
      parent_stats << horse.sire.send(record).send(stat.to_sym)
    end
    if sire_bpf > 5
      (sire_bpf - 5).times do
        parent_stats << horse.sire.send(record).send(stat.to_sym)
      end
    end
    # up to 15 for dam based on BPF
    dam_bpf.times do |n|
      parent_stats << horse.dam.send(record).send(stat.to_sym)
    end
    if dam_bpf > 5
      (dam_bpf - 5).times do
        parent_stats << horse.dam.send(record).send(stat.to_sym)
      end
    end
    # extra for stud if inbred
    sire_inbred = inbreeding[:grandparents].key?(horse.sire_id) || inbreeding[:great_grandparents].key?(horse.sire_id)
    if sire_inbred
      if inbreeding[:grandparents].key?(horse.sire_id)
        inbreeding[:grandparents][horse.sire_id].times do
          parent_stats << horse.sire.send(record).send(stat.to_sym)
        end
      end
      if inbreeding[:great_grandparents].key?(horse.sire_id)
        inbreeding[:great_grandparents][horse.sire_id].times do
          parent_stats << horse.sire.send(record).send(stat.to_sym)
        end
      end
    end
    # extra for dam if inbred
    dam_inbred = inbreeding[:grandparents].key?(horse.dam_id) || inbreeding[:great_grandparents].key?(horse.dam_id)
    if dam_inbred
      if inbreeding[:grandparents].key?(horse.dam_id)
        inbreeding[:grandparents][horse.dam_id].times do
          parent_stats << horse.dam.send(record).send(stat.to_sym)
        end
      end
      if inbreeding[:great_grandparents].key?(horse.dam_id)
        inbreeding[:great_grandparents][horse.dam_id].times do
          parent_stats << horse.dam.send(record).send(stat.to_sym)
        end
      end
    end
    if parent_stats.size > 32
      parent_stats = parent_stats.sample(32)
    else
      (32 - parent_stats.size).times do
        parent_stats << generate_random_stat(stat, quality)
      end
    end

    # grandparents = 16 slots: 3-4 per grandparent (based on BPF and/or inbreeding) + rest random
    grandparent_stats = []
    if horse.sire.sire
      sire_bpf = horse.sire.sire.breeding_stats.breeding_potential_grandparent
      grandparent_stats << horse.sire.sire.send(record).send(stat.to_sym)
      grandparent_stats << horse.sire.sire.send(record).send(stat.to_sym)
      if sire_bpf > 5
        grandparent_stats << horse.sire.sire.send(record).send(stat.to_sym)
      end
      if inbreeding[:grandparents].key?(horse.sire.sire_id) || inbreeding[:great_grandparents].key?(horse.sire.sire_id)
        grandparent_stats << horse.sire.sire.send(record).send(stat.to_sym)
      end
    end
    if horse.sire.dam
      dam_bpf = horse.sire.dam.breeding_stats.breeding_potential_grandparent
      grandparent_stats << horse.sire.dam.send(record).send(stat.to_sym)
      grandparent_stats << horse.sire.dam.send(record).send(stat.to_sym)
      if dam_bpf > 5
        grandparent_stats << horse.sire.dam.send(record).send(stat.to_sym)
      end
      if inbreeding[:grandparents].key?(horse.sire.dam_id) || inbreeding[:great_grandparents].key?(horse.sire.dam_id)
        grandparent_stats << horse.sire.dam.send(record).send(stat.to_sym)
      end
    end
    if horse.dam.sire
      sire_bpf = horse.dam.sire.breeding_stats.breeding_potential_grandparent
      grandparent_stats << horse.dam.sire.send(record).send(stat.to_sym)
      grandparent_stats << horse.dam.sire.send(record).send(stat.to_sym)
      if sire_bpf > 5
        grandparent_stats << horse.dam.sire.send(record).send(stat.to_sym)
      end
      if inbreeding[:grandparents].key?(horse.dam.sire_id) || inbreeding[:great_grandparents].key?(horse.dam.sire_id)
        grandparent_stats << horse.dam.sire.send(record).send(stat.to_sym)
      end
    end
    if horse.dam.dam
      dam_bpf = horse.dam.dam.breeding_stats.breeding_potential_grandparent
      grandparent_stats << horse.dam.dam.send(record).send(stat.to_sym)
      grandparent_stats << horse.dam.dam.send(record).send(stat.to_sym)
      if dam_bpf > 5
        grandparent_stats << horse.dam.dam.send(record).send(stat.to_sym)
      end
      if inbreeding[:grandparents].key?(horse.dam.dam_id) || inbreeding[:great_grandparents].key?(horse.dam.dam_id)
        grandparent_stats << horse.dam.dam.send(record).send(stat.to_sym)
      end
    end
    if grandparent_stats.size > 16
      grandparent_stats = grandparent_stats.sample(16)
    else
      (16 - grandparent_stats.size).times do
        grandparent_stats << generate_random_stat(stat, quality)
      end
    end

    # great-grandparents = 8 slots: 1 per great-grandparent (filled with random if no great-grandparents)
    great_grandparent_stats = []
    if horse.sire.sire&.sire
      great_grandparent_stats << horse.sire.sire.sire.send(record).send(stat.to_sym)
    end
    if horse.sire.sire&.dam
      great_grandparent_stats << horse.sire.sire.dam.send(record).send(stat.to_sym)
    end
    if horse.sire.dam&.sire
      great_grandparent_stats << horse.sire.dam.sire.send(record).send(stat.to_sym)
    end
    if horse.sire.dam&.dam
      great_grandparent_stats << horse.sire.dam.dam.send(record).send(stat.to_sym)
    end
    if horse.dam.sire&.sire
      great_grandparent_stats << horse.dam.sire.sire.send(record).send(stat.to_sym)
    end
    if horse.dam.sire&.dam
      great_grandparent_stats << horse.dam.sire.dam.send(record).send(stat.to_sym)
    end
    if horse.dam.dam&.sire
      great_grandparent_stats << horse.dam.dam.sire.send(record).send(stat.to_sym)
    end
    if horse.dam.dam&.dam
      great_grandparent_stats << horse.dam.dam.dam.send(record).send(stat.to_sym)
    end
    if great_grandparent_stats.size > 8
      great_grandparent_stats = great_grandparent_stats.sample(8)
    else
      (8 - great_grandparent_stats.size).times do
        great_grandparent_stats << generate_random_stat(stat, quality)
      end
    end

    overall_stat = (parent_stats + grandparent_stats + great_grandparent_stats).sum(0).fdiv(32 + 16 + 8).round
    overall_stat.clamp(Config::Racing.dig(:stats, stat, :min), Config::Racing.dig(:stats, stat, :max))
  end

  def generate_random_stat(stat, quality)
    min_percent = Config::Breedings.dig(:stat_generation, :quality, quality, :min)
    max_percent = Config::Breedings.dig(:stat_generation, :quality, quality, :max)
    min_stat = (Config::Racing.dig(:stats, stat, :min) * min_percent).round.clamp(Config::Racing.dig(:stats, stat, :min), Config::Racing.dig(:stats, stat, :max))
    max_stat = (Config::Racing.dig(:stats, stat, :max) * max_percent).round.clamp(Config::Racing.dig(:stats, stat, :min), Config::Racing.dig(:stats, stat, :max))
    rand(min_stat..max_stat)
  end

  def determine_foal_quality(horse:)
    sire_quality = parent_quality_index(horse.sire, :sire)
    dam_quality = parent_quality_index(horse.dam, :dam)

    foal_quality = (sire_quality + dam_quality).fdiv(2).round

    foal_quality = if foal_quality < -70
      1
    elsif foal_quality >= -70 && foal_quality < -50
      2
    elsif foal_quality >= -50 && foal_quality < -30
      3
    elsif foal_quality >= -30 && foal_quality < -10
      4
    elsif foal_quality >= -10 && foal_quality < 10
      5
    elsif foal_quality >= 10 && foal_quality < 30
      6
    elsif foal_quality >= 30 && foal_quality < 50
      7
    elsif foal_quality >= 50 && foal_quality < 70
      8
    elsif foal_quality >= 70 && foal_quality < 90
      9
    else
      10
    end

    chance = rand(1..40)
    random_quality = rand(1..2)

    if foal_quality > 8
      foal_quality = if chance < 5
        (random_quality == 1) ? 9 : 10
      elsif chance > 4 && chance < 20
        (random_quality == 1) ? 7 : 8
      elsif chance > 19 && chance < 30
        (random_quality == 1) ? 5 : 6
      elsif chance > 29 && chance < 37
        (random_quality == 1) ? 3 : 4
      else
        2
      end
    elsif foal_quality > 6 && foal_quality < 9
      foal_quality = if chance < 3
        (random_quality == 1) ? 9 : 10
      elsif chance > 2 && chance < 18
        (random_quality == 1) ? 7 : 8
      elsif chance > 17 && chance < 29
        (random_quality == 1) ? 5 : 6
      elsif chance > 28 && chance < 39
        (random_quality == 1) ? 3 : 4
      else
        2
      end
    elsif foal_quality > 4 && foal_quality < 7
      foal_quality = if chance == 1
        9
      elsif chance > 1 && chance < 13
        (random_quality == 1) ? 7 : 8
      elsif chance > 12 && chance < 28
        (random_quality == 1) ? 5 : 6
      elsif chance > 27 && chance < 39
        (random_quality == 1) ? 3 : 4
      else
        2
      end
    elsif foal_quality > 2 && foal_quality < 5
      foal_quality = if chance == 1
        9
      elsif chance > 1 && chance < 12
        (random_quality == 1) ? 7 : 8
      elsif chance > 11 && chance < 23
        (random_quality == 1) ? 5 : 6
      elsif chance > 22 && chance < 38
        (random_quality == 1) ? 3 : 4
      else
        (random_quality == 1) ? 1 : 2
      end
    elsif foal_quality < 3
      foal_quality = if chance == 1
        9
      elsif chance > 1 && chance < 10
        (random_quality == 1) ? 7 : 8
      elsif chance > 10 && chance < 20
        (random_quality == 1) ? 5 : 6
      elsif chance > 20 && chance < 30
        (random_quality == 1) ? 3 : 4
      else
        (random_quality == 1) ? 1 : 2
      end
    end

    foal_quality
  end

  def parent_quality_index(parent, type)
    quality = parent.quantify

    bpf = (type == :sire) ? sire_bpf : dam_bpf
    if bpf < 3
      quality -= 10
    elsif bpf > 8
      quality += 10
    end

    quality
  end

  def inbred_soundness
    soundness = 0
    soundness += inbreeding[:grandparents].count * 0.5
    soundness += inbreeding[:great_grandparents].count * 0.25
    soundness.ceil
  end

  def calculate_inbreeding(stud, mare)
    @inbreeding = { grandparents: [], great_grandparents: [] }
    grandparents = [stud.sire, stud.dam, mare.sire, mare.dam].compact_blank
    counts = grandparents.group_by { |i| i }.map { |k, v| [k.id, v.count] }
    inbreeding[:grandparents] = Hash[*counts.flatten].reject { |k, v| v == 1 }
    great_grandparents = []
    grandparents.map { |gp|
      great_grandparents << gp.sire_id
      great_grandparents << gp.dam_id
    }
    great_grandparents.compact_blank!
    counts = great_grandparents.group_by { |i| i }.map { |k, v| [k, v.count] }
    inbreeding[:great_grandparents] = Hash[*counts.flatten]
    inbreeding[:great_grandparents] = Hash[*counts.flatten].reject { |k, v| v == 1 }

    inbreeding
  end

  def pick_event
    if rand(1..2000) == 1
      if rand(1..2) == 1
        "twins_alive"
      else
        "twins_death"
      end
    elsif rand(1..500) == 1
      "stillborn"
    elsif rand(1..750) == 1
      "death"
    else
      "birth"
    end
  end

  def pick_gender
    %w[colt filly].sample
  end

  def pick_date_of_birth(gender)
    @premature = false
    case gender.to_s.downcase
    when "colt"
      min_days = 338
      max_days = 345
    else
      min_days = 335
      max_days = 342
    end
    if breeding.mare.foals.born.count < Config::Breedings.mare_inexperienced_foal_count.to_i
      premie_chance = 13
      late_chance = 26
    elsif breeding.mare.age > Config::Breedings.mare_old_breeding_age
      premie_chance = 14
      late_chance = 22
    elsif breeding.event.starts_with?("twins")
      premie_chance = 15
      late_chance = 18
    else
      premie_chance = 10
      late_chance = 20
    end
    random_chance = rand(1..100)
    if random_chance <= premie_chance
      @premature = true
      min_days = 319
      max_days = 325
    elsif random_chance <= late_chance
      min_days = 350
      max_days = 365
    end
    breeding.date + rand(min_days..max_days)
  end

  def location_bred
    breeding.stud.owner.racetrack.location
  end
end

