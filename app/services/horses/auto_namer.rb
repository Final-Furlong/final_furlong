module Horses
  class AutoNamer
    def call
      horses_updated = 0
      Horses::Horse.racehorse.min_age(2).not_created.where(name: nil).find_each do |horse|
        set_name(horse:)
        horses_updated += 1
      end
      Horses::Horse.born.not_stillborn.created.min_age(2).joins(:owner).where(name: nil, owner: { name: Config::Game.stable }).find_each do |horse|
        set_name(horse:)
        horses_updated += 1
      end
      { horses_updated: }
    end

    private

    def set_name(horse:)
      adjective, noun, name = generate_name
      while Horses::Horse.where.not(id: horse.id).exists?(["name LIKE ?", "#{adjective}%#{noun}%"])
        adjective, noun, name = generate_name
      end
      ActiveRecord::Base.transaction do
        horse.update(name:)
        id = horse.legacy_id
        Legacy::Horse.where(ID: id).update(Name: name)
        Legacy::ViewRacehorses.where(horse_id: id).update(horse_name: name)
        Legacy::ViewTrainingSchedules.where(horse_id: id).update(horse_name: name)
        Legacy::ViewBroodmares.where(horse_id: id).update(horse_name: name)
      end
    end

    def generate_name
      name = ""
      adjective = ""
      noun = ""
      while name.length == 0 || name.length > Config::Horses.max_name_length
        adjective = pick_adjective
        noun = pick_noun
        name = "#{adjective} #{noun}"
      end
      [adjective, noun, name]
    end

    def pick_adjective
      Config::Names.adjectives.sample.to_s.capitalize
    end

    def pick_noun
      Config::Names.nouns.sample.to_s.capitalize
    end
  end
end

