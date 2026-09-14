class Game::EclipseAwards::EndOfVotingJob < ApplicationJob
  queue_as :latency_5m

  retry_on ActiveRecord::RecordInvalid

  def perform(category:, year:)
    return unless Game::EclipseAwardContender.voting_ended.exists?(category:)

    if Game::EclipseAwardContender.voting_ended.where(category:).count < 2
      ::Notifications::Game::EclipseAwardVotingNotification.param_equals("category", category).param_equals("year", year).delete_all
      Game::EclipseAwardVote.where(contender: Game::EclipseAwardContender.voting_ended.where(year:, category:)).delete_all
      Game::EclipseAwardContender.voting_ended.where(year:, category:).delete_all
      return
    end

    votes = Game::EclipseAwardVote.where(category:).group(:contender_id).count
    sorted_votes = votes.sort_by { |_, value| -value }.to_h
    winner_id, vote_count = sorted_votes.first
    ties = votes.select { |key, value| value == vote_count }

    ActiveRecord::Base.transaction do
      if ties.count > 1
        old_contender = Game::EclipseAwardContender.find(ties.first.first)
        if old_contender.tie_breaker
          # pick a random winner because the tie-breaker was also tied
          winner_id = ties.keys.sample
          give_award(winner_id:, category:, year:)
        else
          voting_ends_at = (Time.current + Config::Game.eclipse_award_voting_tie_breaker_days.days).end_of_day
          ::Notifications::Game::EclipseAwardVotingNotification.param_equals("category", category).param_equals("year", year).delete_all
          new_contenders = []
          ties.each do |tie|
            old_contender = Game::EclipseAwardContender.find(tie.first)
            contender = Game::EclipseAwardContender.new(awardable_type: old_contender.awardable_type, awardable_id: old_contender.awardable_id, category:, year:)
            contender.tie_breaker = true
            contender.record = old_contender.record
            contender.voting_starts_at = Time.current
            contender.voting_ends_at = voting_ends_at
            new_contenders << contender
          end
          Game::EclipseAwardVote.where(contender: Game::EclipseAwardContender.voting_ended.where(year:, category:)).delete_all
          Game::EclipseAwardContender.voting_ended.where(year:, category:).delete_all
          new_contenders.map(&:save)
          send_new_voting_notifications(category:, year:, end_time: voting_ends_at)
        end
      else
        give_award(winner_id:, category:, year:)
      end
    end
    unless %w[horse stable breeder sire].include?(category)
      # see if we can set up HOTY voting
      horse_categories = Game::EclipseAwardContender::CATEGORIES.dup - %w[horse stable breeder sire sc_colt sc_filly]
      allow_hoty = true
      horse_categories.each do |category|
        if !Game::EclipseAward.exists?(category:, year:)
          allow_hoty = false
          break
        end
      end
      create_hoty_voting(year:) if allow_hoty
    end

    store_job_info(outcome: { year:, category: })
  end

  private

  def create_hoty_voting(year:)
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

  def give_award(winner_id:, category:, year:)
    contender = Game::EclipseAwardContender.find(winner_id)
    winner = contender.awardable
    ActiveRecord::Base.transaction do
      ::Notifications::Game::EclipseAwardVotingNotification.param_equals("category", category).param_equals("year", year).delete_all
      Game::EclipseAward.create!(
        awardable_type: %w[stable breeder].include?(category) ? "Account::Stable" : "Horses::Horse",
        awardable_id: winner.id,
        category:,
        year:
      )
      votes = Game::EclipseAwardVote.where(contender: Game::EclipseAwardContender.voting_ended.where(year:, category:))
      send_voting_ended_notifications(category:, year:, winner:, votes:)
      Game::EclipseAwardVote.where(contender: Game::EclipseAwardContender.voting_ended.where(year:, category:)).delete_all
      Game::EclipseAwardContender.voting_ended.where(year:, category:).delete_all
    end
  end

  def send_voting_ended_notifications(category:, year:, winner:, votes:)
    category_name = I18n.t("eclipse_awards.award.category_#{category}")
    params = { category:, category_name:, year: }
    if %w[stable breeder].include?(category)
      params[:stable_id] = winner.id
      params[:stable_name] = winner.name
    else
      params[:horse_id] = winner.slug
      params[:horse_name] = winner.name
    end
    votes.find_each do |vote|
      stable = vote.voter
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Game::EclipseAwardGivenNotification,
        user: stable.user,
        params:
      )
    end
  end

  def send_new_voting_notifications(category:, year:, end_time:)
    category_name = I18n.t("eclipse_awards.award.category_#{category}")
    Account::User.active.find_each do |user|
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Game::EclipseAwardVotingNotification,
        user:,
        params: { category:, category_name:, year:, deadline: end_time }
      )
    end
  end
end

