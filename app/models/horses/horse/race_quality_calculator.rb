class Horses::Horse::RaceQualityCalculator
  attr_reader :stats

  def initialize(horse:)
    @horse = horse
    @stats = horse.racing_stats
  end

  def run
    quality = 0

    if stats.break_speed < Config::Racing.stats[:break_speed][:max] * 0.2
      quality -= 20
    elsif stats.break_speed < Config::Racing.stats[:break_speed][:max] * 0.3
      quality -= 10
    elsif stats.break_speed < Config::Racing.stats[:break_speed][:max] * 0.5
      quality += 10
    else
      quality += 20
    end

    if stats.min_speed < Config::Racing.stats[:min_speed][:max] * 0.4
      quality -= 10
    elsif stats.min_speed > Config::Racing.stats[:min_speed][:max] * 0.6
      quality += 10
    end

    if stats.average_speed < Config::Racing.stats[:average_speed][:max] * 0.4
      quality -= 10
    elsif stats.average_speed > Config::Racing.stats[:average_speed][:max] * 0.6
      quality += 10
    end

    if stats.max_speed < Config::Racing.stats[:max_speed][:max] * 0.4
      quality -= 10
    elsif stats.max_speed > Config::Racing.stats[:max_speed][:max] * 0.6
      quality += 10
    end

    if stats.sustain < Config::Racing.stats[:sustain][:max] * 0.33
      quality -= 10
    elsif stats.sustain > Config::Racing.stats[:sustain][:max] * 0.67
      quality += 10
    end

    if stats.consistency < Config::Racing.stats[:consistency][:max] * 0.2
      quality -= 20
    elsif stats.consistency < Config::Racing.stats[:consistency][:max] * 0.4
      quality -= 10
    elsif stats.consistency > Config::Racing.stats[:consistency][:max] * 0.8
      quality += 20
    elsif stats.consistency > Config::Racing.stats[:consistency][:max] * 0.6
      quality += 10
    end

    tracks = [stats.dirt, stats.turf, stats.steeplechase]
    ave_track = tracks.sum(0.0) / tracks.size

    if ave_track <= 3
      quality -= 10
    elsif ave_track >= 8
      quality += 10
    end

    if stats.courage < Config::Racing.stats[:courage][:max] * 0.3
      quality -= 1
    elsif stats.courage > Config::Racing.stats[:courage][:max] * 0.8
      quality += 1
    end

    if stats.strides_per_second < Config::Racing.stats[:strides_per_second][:max] * 0.2
      quality -= 20
    elsif stats.strides_per_second < Config::Racing.stats[:strides_per_second][:max] * 0.4
      quality -= 10
    elsif stats.strides_per_second > Config::Racing.stats[:strides_per_second][:max] * 0.6
      quality += 10
    elsif stats.strides_per_second > Config::Racing.stats[:strides_per_second][:max] * 0.8
      quality += 20
    end

    quality
  end
end

