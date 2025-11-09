module Horses
  class LeaseOfferCreator
    attr_reader :offer

    def create_offer(horse:, params:)
      @offer = horse.lease_offer || horse.build_lease_offer
      @offer.owner = horse.owner

      result = Result.new(offer:)
      member_type = params.delete(:member_type)
      offer.new_members_only = member_type == "new_members"
      offer.assign_attributes(params)
      ActiveRecord::Base.transaction do
        if offer.valid? && offer.save
          if offer.leaser
            duration = "#{offer.duration_months} #{"month".pluralize(offer.duration_months)}"
            if offer.offer_start_date <= Date.current
              ::LeaseOfferNotification.create!(
                user: offer.leaser.user,
                params: {
                  offer_id: offer.id,
                  horse_id: horse.slug,
                  horse_name: horse.name,
                  stable_name: horse.owner.name,
                  duration:,
                  fee: Game::MoneyFormatter.new(offer.fee).to_s
                }
              )
            end
          end
          result.created = true
        else
          result.created = false
          result.error = offer.errors.full_messages.to_sentence
        end
        result.offer = offer
      end
      result
    end

    class Result
      attr_accessor :error, :created, :offer

      def initialize(offer:, created: false, error: nil)
        @created = created
        @offer = offer
        @error = nil
      end

      def created?
        @created
      end
    end
  end
end

