module Dashboard
  module Stable
    class RecentResults
      include Rails.application.routes.url_helpers

      attr_reader :results, :starts, :wins, :seconds, :thirds, :fourths,
        :stakes, :stakes_wins, :stakes_seconds, :stakes_thirds,
        :stakes_fourths, :earnings, :points, :claim_result

      def initialize(results:, stable:, date:)
        @results = results
        claimed = stable.budget_transactions.by_date(date).by_type("claimed_horse").debit.first
        if claimed
          description = claimed.description
          horse_name = description.slice(7, description.length - 19)
          @claim_result = ::Racing::RaceResultHorse.joins(:race).includes(:horse).where(race: { date: }).joins(:horse).where(horse: { name: horse_name.strip }).first
          sale = @claim_result.horse.sales.find_by(date:)
          sale.strict_loading!(false)
          @claim_stable = sale.seller
        end
        @starts = results.size
        @wins = win_results.size
        @seconds = second_results.size
        @thirds = third_results.size
        @fourths = fourth_results.size
        @stakes = @stakes_wins = @stakes_seconds = @stakes_thirds = @stakes_fourths = 0
        @earnings = 0
        @points = 0
        results.each do |result|
          @earnings += result.earnings
          @points += result.points
          if result.race.stakes?
            @stakes += 1
            @stakes_wins += 1 if result.finish_position == 1
            @stakes_seconds += 1 if result.finish_position == 2
            @stakes_thirds += 1 if result.finish_position == 3
            @stakes_fourths += 1 if result.finish_position == 4
          elsif result.race.claiming?
            sale = result.horse.sales.find_by(date: result.race.date)
            result.claimed = sale.present?
          end
        end
      end

      def win_results
        @win_results ||= @results.select { |result| result.finish_position == 1 }
      end

      def second_results
        @second_results ||= @results.select { |result| result.finish_position == 2 }
      end

      def third_results
        @third_results ||= @results.select { |result| result.finish_position == 3 }
      end

      def fourth_results
        @fourth_results ||= @results.select { |result| result.finish_position == 4 }
      end

      def fifth_results
        @fifth_results ||= @results.select { |result| result.finish_position == 5 }
      end

      def other_results
        @other_results ||= @results.select { |result| result.finish_position > 5 }
      end

      def results_string
        starts_string = starts.to_s
        starts_string += "(#{stakes})" if stakes.positive?
        wins_string = wins.to_s
        wins_string += "(#{stakes_wins})" if stakes_wins.positive?
        seconds_string = seconds.to_s
        seconds_string += "(#{stakes_seconds})" if stakes_seconds.positive?
        thirds_string = thirds.to_s
        thirds_string += "(#{stakes_thirds})" if stakes_thirds.positive?
        fourths_string = fourths.to_s
        fourths_string += "(#{stakes_fourths})" if stakes_fourths.positive?
        string = [starts_string, wins_string, seconds_string, thirds_string, fourths_string].join("-")
        string += " #{Game::MoneyFormatter.new(earnings)}"
        string + " - " + I18n.t("horse.races.index.points_amount", points: points.to_i)
      end

      def forum_text
        forum_text = "**" + results_string + "**\n\n"
        if win_results.present? || claim_result&.finish_position == 1
          forum_text += I18n.t("racing.race.forum.wins") + "\n"
          win_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position == 1
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        if second_results.present? || claim_result&.finish_position == 2
          forum_text += I18n.t("racing.race.forum.seconds") + "\n"
          second_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position == 2
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        if third_results.present? || claim_result&.finish_position == 3
          forum_text += I18n.t("racing.race.forum.thirds") + "\n"
          third_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position == 3
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        if fourth_results.present? || claim_result&.finish_position == 4
          forum_text += I18n.t("racing.race.forum.fourths") + "\n"
          fourth_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position == 4
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        if fifth_results.present? || claim_result&.finish_position == 5
          forum_text += I18n.t("racing.race.forum.fifths") + "\n"
          fifth_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position == 5
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        if other_results.present? || (claim_result&.finish_position&.> 5)
          forum_text += I18n.t("racing.race.forum.others") + "\n"
          other_results.each do |result|
            forum_text += race_string(result)
          end
          if claim_result&.finish_position&.> 5
            forum_text += race_string(claim_result, @claim_stable.name)
          end
          forum_text += "\n"
        end
        forum_text
      end

      def race_string(result, claim_stable_name = nil)
        string = ""
        horse = result.horse
        claiming_stable = if claim_stable_name.blank? && result.claimed
          sale = horse.sales.find_by(date: result.race.date)
          sale&.buyer&.name
        end
        hex_color = if horse.gelding?
          ::Config::Horses.forum_color_gelding
        else
          horse.female? ? ::Config::Horses.forum_color_female : ::Config::Horses.forum_color_male
        end
        bbcode_name = I18n.t("horse.bbcode_colored_name", color: "##{hex_color}", name: horse.name)
        string += I18n.t("horse.bbcode_url", url: horse_url(horse), name: bbcode_name)
        string += I18n.t("horse.bbcode_age_sire", age: horse.age, sire: horse.sire&.name || I18n.t("horse.created"))
        string += " #{result.finish_position.ordinalize}" unless result.finish_position <= 5
        string += " " + [I18n.t("racing.race.forum.in"), race_type_string(result.race)].join(" ")
        string += I18n.t("racing.race.forum.claimed", stable: claim_stable_name) if claim_stable_name
        string += I18n.t("racing.race.forum.claimed_by", stable: claiming_stable) if claiming_stable
        string + "\n"
      end

      def race_type_string(race)
        if race.stakes?
          grade = I18n.t("racing.race.mobile.#{race.grade.downcase.tr(" ", "_")}")
          I18n.t("racing.race.forum.stakes", name: race.name, grade:)
        else
          prefix_key = race.race_type.to_s.casecmp("allowance").zero? ? "allowance_prefix" : "other_prefix"
          [I18n.t("racing.race.forum.#{prefix_key}"), race_type(race.race_type)].join(" ")
        end
      end

      def race_type(type)
        if type.to_s.downcase == "claiming"
          "Claimer"
        else
          I18n.t("racing.race.#{type.to_s.downcase}")
        end
      end
    end
  end
end

