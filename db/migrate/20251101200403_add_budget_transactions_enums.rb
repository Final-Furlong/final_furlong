class AddBudgetTransactionsEnums < ActiveRecord::Migration[8.1]
  def change
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
