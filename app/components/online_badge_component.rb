class OnlineBadgeComponent < ApplicationComponent
  def initialize(online:)
    @online = online
    super
  end

  private

    attr_reader :online

    def status_i18n_key
      online ? "components.online_badge.online" : "components.online_badge.offline"
    end

    def status_classes
      online ? online_classes : offline_classes
    end

    def online_classes
      "badge bg-success"
    end

    def offline_classes
      "badge bg-light border border-secondary border-opacity-50 text-dark"
    end
end
