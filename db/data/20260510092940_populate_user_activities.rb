# frozen_string_literal: true

class PopulateUserActivities < ActiveRecord::Migration[8.1]
  def up
    Account::User.includes(:stable).find_each do |user|
      activity = user.activity || user.build_activity
      activities = {}
      activity_list.each do |activity|
        activity_time = find_last_activity(activity, user.stable)
        activities[activity.to_sym] = activity_time if activity_time
      end
      activity.update(activities:)
    end
  end

  def down
    Account::UserActivity.find_each do |activity|
      activity.update(activities: {})
    end
  end

  private

  def find_last_activity(activity, stable)
    case activity.to_sym
    when :bought_horse
      bought_horse = stable.budget_transactions.where(activity_type: "bought_horse").maximum(:created_at)
      claimed_horse = stable.budget_transactions.where(activity_type: "claimed_horse").where("amount < 0").maximum(:created_at)
      [bought_horse, claimed_horse].compact_blank.max
    when :sold_horse
      sold_horse = stable.budget_transactions.where(activity_type: "sold_horse").maximum(:created_at)
      claimed_horse = stable.budget_transactions.where(activity_type: "claimed_horse").where("amount > 0").maximum(:created_at)
      [sold_horse, claimed_horse].compact_blank.max
    when :entered_race
      stable.budget_transactions.where(activity_type: "entered_race").maximum(:created_at)
    when :bred_stud
      stable.budget_transactions.where(activity_type: "bred_stud").maximum(:created_at)
    when :bred_mare
      stable.budget_transactions.where(activity_type: "bred_mare").maximum(:created_at)
    when :view_race_results
      nil
    when :view_recent_foals
      nil
    end
  end

  def activity_list
    %w[
      bought_horse
      sold_horse
      entered_race
      bred_stud
      bred_mare
      view_race_results
      view_recent_foals
    ]
  end
end

