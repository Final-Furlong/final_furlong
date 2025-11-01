class UpdateReferencesInNewTables < ActiveRecord::Migration[8.1]
  def up
    statements = [
      "UPDATE new_activations SET
         user_id = (SELECT new_users.id FROM new_users INNER JOIN users ON new_users.username = users.username
                   WHERE users.id = new_activations.old_user_id)",
      "UPDATE new_activity_points SET
         budget_id = (SELECT nbt.id FROM new_budget_transactions nbt INNER JOIN budgets b ON nbt.created_at = b.created_at
                   AND nbt.description = b.description AND nbt.amount = b.amount AND nbt.balance = b.balance
                   WHERE b.id = new_activity_points.old_budget_id),
         stable_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_activity_points.old_stable_id)",
      "UPDATE new_auction_bids SET
         auction_id = (SELECT new_auctions.id FROM new_auctions INNER JOIN auctions ON new_auctions.title = auctions.title
                   WHERE auctions.id = new_auction_bids.old_auction_id),
         bidder_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_auction_bids.old_bidder_id),
         horse_id = (SELECT id FROM auction_horses WHERE old_id = new_auction_bids.old_horse_id)",
      "UPDATE new_auction_consignment_configs SET
         auction_id = (SELECT new_auctions.id FROM new_auctions INNER JOIN auctions ON new_auctions.title = auctions.title
                   WHERE auctions.id = new_auction_consignment_configs.old_auction_id)",
      "UPDATE new_auction_horses SET
         auction_id = (SELECT new_auctions.id FROM new_auctions INNER JOIN auctions ON new_auctions.title = auctions.title
                   WHERE auctions.id = new_auction_horses.old_auction_id),
         horse_id = (SELECT id FROM horses WHERE old_id = new_auction_horses.old_horse_id)",
      "UPDATE new_auctions SET
         auctioneer_id = (SELECT id FROM stables WHERE old_id = new_auctions.old_auctioneer_id)",
      "UPDATE new_broodmare_foal_records SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_broodmare_foal_records.old_horse_id)",
      "UPDATE new_budget_transactions SET
         stable_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_budget_transactions.old_stable_id)",
      "UPDATE new_horse_appearances SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_horse_appearances.old_horse_id)",
      "UPDATE new_horse_attributes SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_horse_attributes.old_horse_id)",
      "UPDATE new_horse_genetics SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_horse_genetics.old_horse_id)",
      "UPDATE new_horses SET
         breeder_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_horses.old_breeder_id),
         dam_id = (SELECT id FROM new_horses WHERE old_id = new_horses.old_dam_id),
         location_bred_id = (SELECT id FROM new_locations WHERE old_id = new_horses.old_location_bred_id),
         owner_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_horses.old_owner_id),
         sire_id = (SELECT id FROM new_horses WHERE old_id = new_horses.old_sire_id)",
      "UPDATE new_race_records SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_race_records.old_horse_id)",
      "UPDATE new_race_result_horses SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_race_result_horses.old_horse_id),
         jockey_id = (SELECT new_jockeys.id FROM new_jockeys INNER JOIN jockeys ON new_jockeys.first_name = jockeys.first_name
                   AND new_jockeys.last_name = jockeys.last_name
                   WHERE jockeys.id = new_race_result_horses.old_jockey_id),
         race_id = (SELECT nrr.id FROM new_race_results nrr INNER JOIN race_results rr ON nrr.date = rr.date
                   AND nrr.number = rr.number
                   WHERE rr.id = new_race_result_horses.old_race_id)",
      "UPDATE new_race_results SET
         surface_id = (SELECT ns.id FROM new_track_surfaces ns INNER JOIN track_surfaces s ON ns.old_racetrack_id = s.racetrack_id
                   WHERE s.id = new_race_results.old_surface_id)",
      "UPDATE new_race_schedules SET
         surface_id = (SELECT ns.id FROM new_track_surfaces ns INNER JOIN track_surfaces s ON ns.old_racetrack_id = s.racetrack_id
                   WHERE s.id = new_race_schedules.old_surface_id)",
      "UPDATE new_racetracks SET
         location_id = (SELECT id FROM new_locations WHERE old_id = new_racetracks.old_location_id)",
      "UPDATE new_sessions SET
         user_id = (SELECT new_users.id FROM new_users INNER JOIN users ON new_users.username = users.username
                    WHERE users.id = new_sessions.old_user_id)",
      "UPDATE new_settings SET
         user_id = (SELECT new_users.id FROM new_users INNER JOIN users ON new_users.username = users.username
                    WHERE users.id = new_settings.old_user_id)",
      "UPDATE new_stables SET
         racetrack_id = (SELECT nr.id FROM new_racetracks nr INNER JOIN racetracks ON nr.name = racetracks.name
                    WHERE racetracks.id = new_stables.old_racetrack_id),
         user_id = (SELECT new_users.id FROM new_users INNER JOIN users ON new_users.username = users.username
                    WHERE users.id = new_stables.old_user_id)",
      "UPDATE new_track_surfaces SET
         racetrack_id = (SELECT nr.id FROM new_racetracks nr INNER JOIN racetracks ON nr.name = racetracks.name
                    WHERE racetracks.id = new_track_surfaces.old_racetrack_id)",
      "UPDATE new_training_schedules SET
         stable_id = (SELECT new_stables.id FROM new_stables INNER JOIN stables ON new_stables.name = stables.name
                   WHERE stables.id = new_training_schedules.old_stable_id)",
      "UPDATE new_training_schedules_horses SET
         horse_id = (SELECT id FROM new_horses WHERE old_id = new_training_schedules_horses.old_horse_id),
         training_schedule_id = (SELECT nts.id FROM new_training_schedules nts INNER JOIN training_schedules ts ON nts.old_stable_id = ts.stable_id
                   AND nts.name = ts.name
                   WHERE ts.id = new_training_schedules_horses.old_training_schedule_id)",
      "UPDATE new_user_push_subscriptions SET
         user_id = (SELECT new_users.id FROM new_users INNER JOIN users ON new_users.username = users.username
                    WHERE users.id = new_user_push_subscriptions.old_user_id)",
    ]
    statements.each do |sql|
      ActiveRecord::Base.connection.execute(sql)
      puts sql
    end
  end

  def down
    statements = [
      "UPDATE new_activations SET user_id = NULL",
      "UPDATE new_activity_points SET budget_id = NULL, stable_id = NULL",
      "UPDATE new_auction_bids SET auction_id = NULL, bidder_id = NULL, horse_id = NULL",
      "UPDATE new_auction_consignment_configs SET auction_id = NULL",
      "UPDATE new_auction_horses SET auction_id = NULL, horse_id = NULL",
      "UPDATE new_auctionses SET auctioneer_id = NULL, horse_id = NULL",
      "UPDATE new_broodmare_foal_records SET horse_id = NULL",
      "UPDATE new_budget_transactions SET stable_id = NULL",
      "UPDATE new_horse_appearances SET horse_id = NULL",
      "UPDATE new_horse_attributes SET horse_id = NULL",
      "UPDATE new_horse_genetics SET horse_id = NULL",
      "UPDATE new_horses SET breeder_id = NULL, dam_id = NULL, location_id = NULL, owner_id = NULL, sire_id = NULL",
      "UPDATE new_race_records SET horse_id = NULL",
      "UPDATE new_race_result_horses SET horse_id = NULL, jockey_id = NULL, race_id = NULL",
      "UPDATE new_race_results SET surface_id = NULL",
      "UPDATE new_race_schedules SET surface_id = NULL",
      "UPDATE new_racetracks SET location_id = NULL",
      "UPDATE new_sessions SET user_id = NULL",
      "UPDATE new_settings SET user_id = NULL",
      "UPDATE new_stables SET racetrack_id = NULL, user_id = NULL",
      "UPDATE new_track_surfaces SET racetrack_id = NULL",
      "UPDATE new_training_schedules SET stable_id = NULL",
      "UPDATE new_training_schedules_horses SET horse_id = NULL, training_schedule_id = NULL",
      "UPDATE new_user_push_notifications SET user_id = NULL",
    ]
    ActiveRecord::Base.transaction do
      statements.each do |sql|
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
