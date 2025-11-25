module Horses
  class BroodmareFoalRecordCreator < ApplicationService
    attr_reader :horse

    def create_record(horse:)
      return unless horse.female?

      record = horse.broodmare_foal_record || horse.build_broodmare_foal_record
      attrs = {
        born_foals_count: horse.foals.born.count,
        stillborn_foals_count: horse.foals.born.stillborn.count,
        unborn_foals_count: horse.foals.unborn.count,
        total_foal_points: 0,
        total_foal_races: 0,
        total_foal_earnings: 0
      }
      if attrs[:born_foals_count].positive?
        attrs[:raced_foals_count] = horse.foals.born.where.associated(:lifetime_race_record).count
        if attrs[:raced_foals_count].positive?
          attrs[:winning_foals_count] = horse.foals.born.joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.winner).count
          if attrs[:winning_foals_count].positive?
            attrs[:stakes_winning_foals_count] = horse.foals.born.joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.stakes_winner).count
            attrs[:multi_stakes_winning_foals_count] = horse.foals.born.joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.multi_stakes_winner).count
            attrs[:stakes_winning_foals_count] += attrs[:multi_stakes_winning_foals_count]
          end
          attrs[:millionaire_foals_count] = horse.foals.born.joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.millionaire).count
          attrs[:multi_millionaire_foals_count] = horse.foals.born.joins(:lifetime_race_record).merge(::Racing::LifetimeRaceRecord.multi_millionaire).count
          attrs[:total_foal_points] = ::Racing::LifetimeRaceRecord.where(horse_id: horse.foals.born.select(:id)).sum(:points).to_i
          attrs[:total_foal_races] = ::Racing::LifetimeRaceRecord.where(horse_id: horse.foals.born.select(:id)).sum(:starts).to_i
          attrs[:total_foal_earnings] = ::Racing::LifetimeRaceRecord.where(horse_id: horse.foals.born.select(:id)).sum(:earnings).to_i
        end
      end
      average_points = if attrs[:total_foal_points].positive? && attrs[:total_foal_races].positive?
        attrs[:total_foal_points].fdiv(attrs[:total_foal_races])
      end
      if average_points.to_i.positive?
        breed_ranking = if average_points <= 3.0
          "bronze"
        elsif average_points <= 6.0
          "silver"
        elsif average_points <= 10.0
          (attrs[:total_foal_races] < 30) ? "silver" : "gold"
        elsif average_points > 10.0
          (attrs[:total_foal_races] < 50) ? "gold" : "platinum"
        end
        attrs[:breed_ranking] = breed_ranking
      end

      record.assign_attributes(attrs)
      if record.save!
        Result.new(created: true, record:)
      else
        Result.new(created: false, record:, error: record.errors.full_messages.to_sentence)
      end
    end

    class Result
      attr_reader :record, :error

      def initialize(created:, record:, error: nil)
        @created = created
        @record = record
        @error = nil
      end

      def created?
        @created
      end
    end
  end
end

