# frozen_string_literal: true

class UpdateSlugsAndPublicIds < ActiveRecord::Migration[8.1]
  def up
    Horses::Horse.where(public_id: nil).find_each(&:save)
    Horses::Horse.where(slug: nil).find_each(&:save)

    Account::User.where(public_id: nil).find_each(&:save)
    Account::User.where(slug: nil).find_each(&:save)

    Account::Stable.where(public_id: nil).find_each(&:save)
    Account::Stable.where(slug: nil).find_each(&:save)

    Auction.where(public_id: nil).find_each(&:save)
    Auction.where(slug: nil).find_each(&:save)
    Auctions::Horse.where(public_id: nil).find_each(&:save)
    Auctions::Horse.where(slug: nil).find_each(&:save)

    Racing::Jockey.where(public_id: nil).find_each(&:save)
    Racing::Jockey.where(slug: nil).find_each(&:save)

    Racing::Racetrack.where(public_id: nil).find_each(&:save)
    Racing::Racetrack.where(slug: nil).find_each(&:save)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

