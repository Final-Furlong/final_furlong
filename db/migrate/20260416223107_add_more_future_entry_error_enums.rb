class AddMoreFutureEntryErrorEnums < ActiveRecord::Migration[8.1]
  def change
    add_enum_value :future_entry_errors, "energy_too_low"
    add_enum_value :future_entry_errors, "too_few_days_since_last_race"
    add_enum_value :future_entry_errors, "too_few_days_since_last_injury"
    add_enum_value :future_entry_errors, "too_few_rest_days"
    add_enum_value :future_entry_errors, "too_few_workouts"
  end
end

