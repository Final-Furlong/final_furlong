class MigrateActivityPoints < ActiveRecord::Migration[8.0]
  def up
    Legacy::ActivityPoint.find_each do |activity_point|
      activity = Game::Activity.find_or_initialize_by(activity_type: activity_point.Keyword.downcase.tr(" ", "_"))
      activity.update(
        first_year_points: activity_point.send(:"1stYearPts"),
        second_year_points: activity_point.send(:"2ndYearPts"),
        older_year_points: activity_point.OtherPts
      )
    end

    Legacy::Activity.order(created_at: :asc).find_each do |activity|
      stable = Account::Stable.find_by(legacy_id: activity.Stable)
      next unless stable

      activity_type = case activity.Type
      when 1 then "color_war"
      when 2 then "auction"
      when 3 then "selling"
      when 4 then "buying"
      when 5 then "breeding"
      when 6 then "claiming"
      when 7 then "entering"
      when 8 then "redeem"
      end
      next unless activity_type

      attrs = {
        stable:,
        activity_type:,
        date: Date.parse(activity.Date.to_s) - 4.years
      }
      attrs[:amount] = activity.amount * -1 if activity_type == "redeem"
      Accounts::ActivityTransactionCreator.new.create_transaction(**attrs)
    end
  end

  def down
    Game::Activity.delete_all
    Account::Activity.delete_all
  end
end

