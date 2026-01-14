module CurrentStable
  class TrainingsController < ::AuthenticatedController
    skip_after_action :verify_pundit_authorization, only: :index

    def index
      authorize %i[current_stable training]
    end
  end
end

