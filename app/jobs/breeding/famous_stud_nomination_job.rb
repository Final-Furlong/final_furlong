class Breeding::FamousStudNominationJob < ApplicationJob
  queue_as :latency_30s

  def perform
    deadline = Date.current + Config::Game.famous_stud_nominating_days.days
    send_notifications(deadline)
  end

  private

  def send_notifications(deadline)
    Account::User.active.find_each do |user|
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Breeding::Stud::FamousStudNominationNotification,
        user:,
        params: { date: deadline }
      )
    end
  end
end

