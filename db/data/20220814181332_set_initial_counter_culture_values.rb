class SetInitialCounterCultureValues < ActiveRecord::Migration[7.0]
  def up
    Horse.counter_culture_fix_counts
  end

  def down
    Horse.counter_culture_fix_counts
  end
end

