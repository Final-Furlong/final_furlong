module RaceRunnable
  extend ActiveSupport::Concern

  included do
    def options_for_jockey_select(type)
      Racing::Jockey.active.send(type.to_sym).ordered_by_name.all.map do |jockey|
        [jockey.full_name, jockey.id]
      end
    end

    def options_for_style_select
      Config::Racing.styles.map do |style|
        [I18n.t("racing.style.#{style}"), style]
      end
    end

    def racehorse_type
      return unless horse

      horse.race_options&.racehorse_type
    end
  end
end

