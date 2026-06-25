module Api
  module V1
    class RaceSchedules < Grape::API
      include Api::V1::Defaults

      resource :race_schedules do
        desc "Fetch upcoming race info info"
        params do
          requires :id, type: Integer, desc: "Race Schedule ID"
        end
        route_param :id do
          get do
            race = ::Racing::RaceSchedule.find(params[:id])
            ::Racing::RaceScheduleBlueprint.render_as_json(race)
          end
        end
      end
    end
  end
end

