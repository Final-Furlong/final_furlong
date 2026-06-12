# frozen_string_literal: true

class Create2018HotyContenders < ActiveRecord::Migration[8.1]
  def up
    year = 2018
    category = "horse"
    start_time = Date.current.beginning_of_day
    end_time = (start_time + Config::Game.eclipse_award_voting_days.days).end_of_day
    categories = %w[horse stable breeder sire]
    Game::EclipseAward.where(year:, awardable_type: "Horses::Horse").where.not(category: categories).find_each do |award|
      horse = award.awardable

      contender = Game::EclipseAwardContender.find_or_initialize_by(awardable: horse, category:)
      contender.update(
        year:,
        voting_starts_at: start_time,
        voting_ends_at: end_time
      )
    end
    category_name = I18n.t("eclipse_awards.award.category_horse")
    Account::User.active.find_each do |user|
      Game::NotificationCreator.new.create_notification(
        type: ::EclipseAwardVotingNotification,
        user:,
        params: { category:, category_name:, year:, deadline: end_time }
      )
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
