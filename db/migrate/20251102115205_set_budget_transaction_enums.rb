class SetBudgetTransactionEnums < ActiveRecord::Migration[8.1]
  def change
    add_enum_value :budget_activity_type, "sold_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "bought_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "bred_mare", if_not_exists: true
    add_enum_value :budget_activity_type, "bred_stud", if_not_exists: true
    add_enum_value :budget_activity_type, "claimed_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "entered_race", if_not_exists: true
    add_enum_value :budget_activity_type, "shipped_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "race_winnings", if_not_exists: true
    add_enum_value :budget_activity_type, "jockey_fee", if_not_exists: true
    add_enum_value :budget_activity_type, "nominated_racehorse", if_not_exists: true
    add_enum_value :budget_activity_type, "nominated_stallion", if_not_exists: true
    add_enum_value :budget_activity_type, "boarded_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "opening_balance", if_not_exists: true
    add_enum_value :budget_activity_type, "paid_tax", if_not_exists: true
    add_enum_value :budget_activity_type, "handicapping_races", if_not_exists: true
    add_enum_value :budget_activity_type, "nominated_breeders_series", if_not_exists: true
    add_enum_value :budget_activity_type, "consigned_auction", if_not_exists: true
    add_enum_value :budget_activity_type, "leased_horse", if_not_exists: true
    add_enum_value :budget_activity_type, "color_war", if_not_exists: true
    add_enum_value :budget_activity_type, "activity_points", if_not_exists: true
    add_enum_value :budget_activity_type, "donation", if_not_exists: true
    add_enum_value :budget_activity_type, "won_breeders_series", if_not_exists: true
    add_enum_value :budget_activity_type, "misc", if_not_exists: true
  end
end

