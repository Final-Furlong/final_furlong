module Horses
  class LeaseCreator
    attr_reader :offer

    def accept_offer(horse:, stable:)
      offer = horse.lease_offer
      result = Result.new(horse:)
      unless offer
        result.error = i18n("not_for_lease")
        return result
      end

      available_balance = stable.available_balance
      if available_balance.nil? || available_balance < offer.fee
        result.error = i18n("cannot_afford_lease")
        return result
      end

      lease = Horses::Lease.new(
        horse:,
        owner: horse.owner,
        leaser: stable,
        start_date: Date.current,
        end_date: Date.current + offer.duration_months.months,
        fee: offer.fee,
        active: true
      )
      ActiveRecord::Base.transaction do
        if lease.valid? && lease.save
          description = i18n("description_leaser",
            horse: horse.name,
            stable: horse.owner.name,
            start_date: I18n.l(Date.current, locale: horse.owner.user.locale || I18n.default_locale),
            end_date: I18n.l(lease.end_date, locale: horse.owner.user.locale || I18n.default_locale))
          Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description:, amount: lease.fee.abs * -1)
          description = i18n("description_owner",
            horse: horse.name,
            stable: stable.name,
            start_date: I18n.l(Date.current),
            end_date: I18n.l(lease.end_date))
          Accounts::BudgetTransactionCreator.new.create_transaction(stable: horse.owner, description:, amount: lease.fee.abs)

          ::LeaseAcceptanceNotification.create!(
            user: horse.owner.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name,
              stable_name: stable.name,
              fee: Game::MoneyFormatter.new(lease.fee).to_s
            }
          )
          LeaseOfferNotification.param_equals(:offer_id, offer.id).delete_all
          offer.destroy!
          result.created = true
        else
          result.created = false
          result.error = lease.errors.full_messages.to_sentence
        end
        result.lease = lease
      end
      result
    end

    class Result
      attr_accessor :error, :created, :lease

      def initialize(horse:, created: false, error: nil)
        @created = created
        @horse = horse
        @lease = nil
        @error = nil
      end

      def created?
        @created
      end
    end

    def i18n(key, attrs)
      I18n.t("services.lease_creator.#{key}", **attrs)
    end
  end
end

