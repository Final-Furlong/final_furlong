module Stud
  class FamousStudNominator
    def create_nomination(nomination:, stable:, params:)
      result = Result.new

      if Horses::Stud::FamousStudNomination.exists?(name: params[:name])
        result.error = I18n.t("services.famous_stud_nominator.already_nominated")
        return result
      end

      nomination.submitter = stable.user
      nomination.name = params["name"]
      nomination.color = params["color"]
      nomination.date_of_birth = params["date_of_birth"]
      nomination.face_marking = params["face_marking"].presence
      nomination.height = params["height"]
      nomination.lf_leg_marking = params["lf_leg_marking"].presence
      nomination.lh_leg_marking = params["lh_leg_marking"].presence
      nomination.rf_leg_marking = params["rf_leg_marking"].presence
      nomination.rh_leg_marking = params["rh_leg_marking"].presence
      nomination.ran_on_dirt = params.key?("ran_on_dirt")
      nomination.ran_on_turf = params.key?("ran_on_turf")
      nomination.ran_on_jumps = params.key?("ran_on_steeplechase")
      nomination.sire_name = params["sire_name"].presence
      nomination.highlights = params["highlights"]
      nomination.sire_id = params["sire_id"].presence

      result.created = nomination.save
      result
    end

    class Result
      attr_accessor :created, :error

      def initialize(created: false, error: nil)
        @created = created
        @error = error
      end

      def created?
        @created
      end
    end
  end
end

