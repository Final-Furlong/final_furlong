module CurrentStable
  class SettingsController < AuthenticatedController
    def new
      authorize %i[current_stable settings]
    end
  end
end

