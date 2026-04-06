module Racing
  class ClaimsController < AuthenticatedController
    def create
      race_entry = Racing::RaceEntry.find(params[:entry_id])
      authorize race_entry, :claim?

      race_date = race_entry.race.date
      if Racing::Claim.create!(entry: race_entry, race_date:, claimer: Current.stable, owner: race_entry.horse.owner)
        flash[:success] = t(".success")
      else
        flash[:error] = t(".failure")
      end
      redirect_to post_parade_racing_races_path(date: race_date)
    end

    def destroy
      claim = Racing::Claim.find(params[:id])
      authorize claim.entry, :delete_claim?

      if claim.destroy
        flash[:success] = t(".success")
      else
        flash[:error] = t(".failure")
      end
      redirect_to post_parade_racing_races_path(date: claim.entry.race.date)
    end
  end
end

