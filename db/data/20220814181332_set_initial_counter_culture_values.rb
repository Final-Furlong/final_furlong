class SetInitialCounterCultureValues < ActiveRecord::Migration[7.0]
  def up
    Horses::Horse.counter_culture_fix_counts
  end

  def down
    Horses::Horse.counter_culture_fix_counts
  end
end

