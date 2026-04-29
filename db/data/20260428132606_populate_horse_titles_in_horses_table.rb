# frozen_string_literal: true

class PopulateHorseTitlesInHorsesTable < ActiveRecord::Migration[8.1]
  def up
    Racing::LifetimeRaceRecord.where.not(title_abbreviation: nil).find_each do |lrr|
      lrr.horse.update(title_abbr: lrr.title_abbreviation)
    end
  end

  def down
    Horses::Horse.where.not(title_abbr: nil).find_each do |horse|
      horse.update(title_abbr: nil)
    end
  end
end
